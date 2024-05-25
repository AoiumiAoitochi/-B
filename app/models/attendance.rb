class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  validates :overtime_instruction, length: { maximum: 50 }
  validates :supervisor, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "を入力してください。") if started_at.blank? && finished_at.present?
  end

  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は入力できません。") if started_at > finished_at
    end
  end

   # 出勤時間のみの登録を無効にするためのバリデーション
   validate :cannot_register_started_at_without_finished_at

   private

   def cannot_register_started_at_without_finished_at
     errors.add(:started_at, "を登録する場合は、退勤時間も入力してください。") if started_at.present? && finished_at.blank?
   end
end

module ApplicationHelper

  # ページごとにタイトルを返す
  def full_title(page_name = "") # メソッドと引数の定義
    base_title = "AttendanceApp" # 基本となるアプリケーション名を変数に代入
    if page_name.empty? # 引数を受け取っているか判定
      base_title # 引数page_nameが空文字の場合はbase_titleのみ返す
    else # 引数page_nameが空文字ではない場合
      page_name + " | " + base_title # 文字列を連結して返す
    end
  end


  def weekend?(date)
    date.saturday? || date.sunday?
  end

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    false
  end
end

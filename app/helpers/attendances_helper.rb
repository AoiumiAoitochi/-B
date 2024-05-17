module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end

  def working_times(start, finish)
    # 開始時間から終了時間までの分単位での差を計算
    diff_in_minutes = (finish - start) / 60

    # 在社時間を15分単位に丸める
    rounded_minutes = (diff_in_minutes / 15.0).round * 15

    # 15分単位の在社時間を時間に変換
    hours = rounded_minutes / 60

    # 分単位の残りを計算
    remainder_minutes = rounded_minutes % 60

    # 在社時間を小数点第2位までの文字列にフォーマットして返す
    format("%.2f", hours + remainder_minutes / 100.0)
  end



end

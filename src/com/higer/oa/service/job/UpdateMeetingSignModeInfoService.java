package com.higer.oa.service.job;

import java.util.List;
import java.util.Optional;

import com.higer.oa.dao.UpdateMeetingSignModeInfoDao;

import weaver.interfaces.schedule.BaseCronJob;

public class UpdateMeetingSignModeInfoService extends BaseCronJob {
	public void execute() {
		dealData();
	}

	/**
	 * 处理会议变更的数据
	 */
	public void dealData() {
		UpdateMeetingSignModeInfoDao um = new UpdateMeetingSignModeInfoDao();
		List<String> delMtList = um.getDelMeetingIdList();
		delMtList.forEach(mtid -> {
			Optional<String> optional = Optional.of(mtid);
			optional.ifPresent(item -> um.delMeetingData(item));
		});

		List<String> updateMtList = um.getUpdateMeetingIdList();
		updateMtList.forEach(mtid -> {
			Optional<String> optional = Optional.of(mtid);
			optional.ifPresent(item -> um.UpdateMeetingData(item));
		});
	}
}

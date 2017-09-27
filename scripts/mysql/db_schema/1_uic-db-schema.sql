create database falcon_uic
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;
USE falcon_uic;
SET NAMES utf8;

DROP TABLE if exists team;
CREATE TABLE `team` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `resume` varchar(255) not null default '',
  `creator` int(10) unsigned NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_team_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/**
 * role: -1:blocked 0:normal 1:admin 2:root
 */
DROP TABLE if exists `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `passwd` varchar(64) not null default '',
  `cnname` varchar(128) not null default '',
  `email` varchar(255) not null default '',
  `phone` varchar(16) not null default '',
  `im` varchar(32) not null default '',
  `qq` varchar(16) not null default '',
  `role` tinyint not null default 0 COMMENT '2:超级管理员, 1:管理员, 0:普通用户',
  `creator` int(10) unsigned NOT NULL DEFAULT 0,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE if exists `rel_team_user`;
CREATE TABLE `rel_team_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tid` int(10) unsigned not null,
  `uid` int(10) unsigned not null,
  PRIMARY KEY (`id`),
  KEY `idx_rel_tid` (`tid`),
  KEY `idx_rel_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE if exists `session`;
CREATE TABLE `session` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned not null,
  `sig` varchar(32) not null,
  `expired` int(10) unsigned not null,
  PRIMARY KEY (`id`),
  KEY `idx_session_uid` (`uid`),
  KEY `idx_session_sig` (`sig`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 初始化超管用户
insert into `user`(`name`, `passwd`, `role`, `created`) values('root', md5('123456'), 2, now());



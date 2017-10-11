#-*- coding:utf-8 -*-
from rrd import config
import logging
logging.basicConfig(
        format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s - %(message)s',
        datefmt="%Y-%m-%d %H:%M:%S",
        level=config.LOG_LEVEL)


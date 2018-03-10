Date: Sat, 10 Mar 2018 00:27:02 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 0/2] Remove VLA usage in rtc-s5m
Message-ID: <cover.1520660422.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Sangbeom Kim <sbkim73@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patchset aims to remove VLA usage from rtc-s5m.

The first patch moves an enum from rtc.h to rtc-s5m.c, as this is the
only driver in which such enum is actually being used [1].

The second patch adds the enum name RTC_MAX_NUM_TIME_REGS, which will
be used as a maximum length to the current VLAs, hence turning them
into fixed-length arrays instead.

[1] https://marc.info/?l=linux-rtc&m=152060068925948&w=2

Thanks

Gustavo A. R. Silva (2):
  rtc: s5m: move enum from rtc.h to rtc-s5m.c
  rtc: s5m: Remove VLA usage

 drivers/rtc/rtc-s5m.c           | 25 +++++++++++++++++++------
 include/linux/mfd/samsung/rtc.h | 11 -----------
 2 files changed, 19 insertions(+), 17 deletions(-)

-- 
2.7.4

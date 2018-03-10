Date: Sat, 10 Mar 2018 00:27:15 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 1/2] rtc: s5m: Move enum from rtc.h to rtc-s5m.c
Message-ID: <44ee5bd5053d579dc6c46b21e2ef8f6acf70e4ce.1520660422.git.gustavo@embeddedor.com>
References: <cover.1520660422.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1520660422.git.gustavo@embeddedor.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

Move this enum to rtc-s5m.c once it is meaningless to others drivers [1].

[1] https://marc.info/?l=linux-rtc&m=152060068925948&w=2

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/rtc/rtc-s5m.c           | 11 +++++++++++
 include/linux/mfd/samsung/rtc.h | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 6deae10..4c363de 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -38,6 +38,17 @@
  */
 #define UDR_READ_RETRY_CNT	5
 
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_DATE,
+	RTC_MONTH,
+	RTC_YEAR1,
+	RTC_YEAR2,
+};
+
 /*
  * Registers used by the driver which are different between chipsets.
  *
diff --git a/include/linux/mfd/samsung/rtc.h b/include/linux/mfd/samsung/rtc.h
index 48c3c5b..9ed2871 100644
--- a/include/linux/mfd/samsung/rtc.h
+++ b/include/linux/mfd/samsung/rtc.h
@@ -141,15 +141,4 @@ enum s2mps_rtc_reg {
 #define WTSR_ENABLE_SHIFT	6
 #define WTSR_ENABLE_MASK	(1 << WTSR_ENABLE_SHIFT)
 
-enum {
-	RTC_SEC = 0,
-	RTC_MIN,
-	RTC_HOUR,
-	RTC_WEEKDAY,
-	RTC_DATE,
-	RTC_MONTH,
-	RTC_YEAR1,
-	RTC_YEAR2,
-};
-
 #endif /*  __LINUX_MFD_SEC_RTC_H */
-- 
2.7.4

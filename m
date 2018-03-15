From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2 0/4] VLA removal from the gpio subsystem
Date: Thu, 15 Mar 2018 11:00:26 -0700
Message-Id: <20180315180030.20001-1-labbott@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Nandor Han <nandor.han@ge.com>, Patrice Chotard <patrice.chotard@st.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v2 of the series to remove VLAs from the kernel. This is mostly
to collect some of the feedback I've gotten so far, more detailed
descriptions are in the individual patches.

Thanks,
Laura

Laura Abbott (4):
  gpio: Remove VLA from gpiolib
  gpio: Remove VLA from MAX3191X driver
  gpio: Remove VLA from xra1403 driver
  gpio: Remove VLA from stmpe driver

 drivers/gpio/gpio-max3191x.c  |  7 +++-
 drivers/gpio/gpio-stmpe.c     |  7 +++-
 drivers/gpio/gpio-xra1403.c   |  8 ++++-
 drivers/gpio/gpiolib.c        | 78 ++++++++++++++++++++++++++++++++++---------
 drivers/gpio/gpiolib.h        |  2 +-
 include/linux/gpio/consumer.h |  8 +++--
 6 files changed, 87 insertions(+), 23 deletions(-)

-- 
2.14.3

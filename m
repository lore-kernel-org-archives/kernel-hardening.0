From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 0/4] VLA removal from the GPIO subsystem
Date: Fri,  9 Mar 2018 16:10:17 -0800
Message-Id: <20180310001021.6437-1-labbott@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

For those who haven't seen it, there's an effort to remove VLAs from the
kernel so we can turn on -Wvla in the name of security. See
https://lkml.org/lkml/2018/3/7/621 for more details and discussion.

This is a series to remove a few VLAs from the gpio subsystem. These are
compile tested only so I'd appreciate reviews and tests from
maintainers. When these get Acked, I expect these to just go through the
GPIO tree like usual.

Thanks,
Laura

Laura Abbott (4):
  gpio: Remove VLA from gpiolib
  gpio: Remove VLA from MAX3191X driver
  gpio: Remove VLA from xra1403 driver
  gpio: Remove VLA from stmpe driver

 drivers/gpio/gpio-max3191x.c |  7 +++++-
 drivers/gpio/gpio-stmpe.c    |  7 +++++-
 drivers/gpio/gpio-xra1403.c  |  8 ++++++-
 drivers/gpio/gpiolib.c       | 55 ++++++++++++++++++++++++++++++++++++++------
 4 files changed, 67 insertions(+), 10 deletions(-)

-- 
2.14.3

Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170104194707.GD25268@kroah.com>
References: <20170103225831.GA113525@beast> <20170104093236.GB31677@kroah.com>
 <CAPeXnHudW-YDmoK8NrFzQgAq4WuRDgFNC5-0GaG0+jVkq+3meQ@mail.gmail.com>
 <CAPeXnHue8hKFiMsddMTN7Hb5RWBGXWUgy2-kpXNLwBfOdf0QVA@mail.gmail.com> <20170104194707.GD25268@kroah.com>
From: Matthew Garrett <mjg59@coreos.com>
Date: Wed, 4 Jan 2017 14:01:00 -0600
Message-ID: <CAPeXnHs1=jCGtSgOO859bp2chMWBX1L6VaKn65RKoLaTbVq_0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Allow userspace control of runtime disabling/enabling of
 driver probing
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Ulf Hansson <ulf.hansson@linaro.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Lukas Wunner <lukas@wunner.de>, Madalin Bucur <madalin.bucur@nxp.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Petr Tesarik <ptesarik@suse.com>, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 4, 2017 at 1:47 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> You know the device type and vendor/product id before you authorize it,
> you should be able to do this type of detection otherwise it seems
> pretty pointless :)

You know the vendor and product ID, which doesn't tell you whether one
of the endpoints is a network device or a keyboard. You need to know
that.

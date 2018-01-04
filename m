Date: Thu, 4 Jan 2018 18:35:04 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20180104183504.GQ28752@n2100.armlinux.org.uk>
References: <20180104122801.GA3038@pjb1027-Latitude-E5410>
 <CAGXu5j+YsB1FWvZHEjnixU8RMpk-DLDYLXXmxfQjsU_gy64ZDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+YsB1FWvZHEjnixU8RMpk-DLDYLXXmxfQjsU_gy64ZDQ@mail.gmail.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [kernel-hardening] [PATCH] arm: Always use REFCOUNT_FULL
To: Kees Cook <keescook@chromium.org>
Cc: Jinbum Park <jinb.park7@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 04, 2018 at 10:32:46AM -0800, Kees Cook wrote:
> On Thu, Jan 4, 2018 at 4:28 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> > arm prefers to use REFCOUNT_FULL by default.
> > This enables it for arm.
> >
> > Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
> 
> Acked-by: Kees Cook <keescook@chromium.org>

I'd help if there was some kind of explanation about this.  Not
everyone knows what REFCOUNT_FULL is.

Also, why does "arm" "prefer" to use this?  Where does the preference
come from - and why is it a preference but being enforced by the
Kconfig ?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up

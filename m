Date: Thu, 4 Jan 2018 18:47:41 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20180104184741.GR28752@n2100.armlinux.org.uk>
References: <20180104122801.GA3038@pjb1027-Latitude-E5410>
 <CAGXu5j+YsB1FWvZHEjnixU8RMpk-DLDYLXXmxfQjsU_gy64ZDQ@mail.gmail.com>
 <20180104183504.GQ28752@n2100.armlinux.org.uk>
 <CAGXu5jKkw7aCN7N8P-UkoFH2xF8Szy-UsL5tJBYUQKaW2a38yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKkw7aCN7N8P-UkoFH2xF8Szy-UsL5tJBYUQKaW2a38yA@mail.gmail.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [kernel-hardening] [PATCH] arm: Always use REFCOUNT_FULL
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Jinbum Park <jinb.park7@gmail.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 04, 2018 at 10:42:21AM -0800, Kees Cook wrote:
> On Thu, Jan 4, 2018 at 10:35 AM, Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
> > On Thu, Jan 04, 2018 at 10:32:46AM -0800, Kees Cook wrote:
> >> On Thu, Jan 4, 2018 at 4:28 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> >> > arm prefers to use REFCOUNT_FULL by default.
> >> > This enables it for arm.
> >> >
> >> > Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
> >>
> >> Acked-by: Kees Cook <keescook@chromium.org>
> >
> > I'd help if there was some kind of explanation about this.  Not
> > everyone knows what REFCOUNT_FULL is.
> >
> > Also, why does "arm" "prefer" to use this?  Where does the preference
> > come from - and why is it a preference but being enforced by the
> > Kconfig ?
> 
> This came from discussions with Will Deacon (and others) during the
> Linux Security Summit. The arm64 side of this is in commit
> 4adcec1164de ("arm64: Always use REFCOUNT_FULL"). AIUI, Will said he
> didn't want the specialized "fast but technically incomplete"
> refcounting as seen with x86's fast refcount infrastructure, but
> rather to keep refcounts always fully protected by default because no
> one could point to real-world performance impacts with REFCOUNT_FULL
> vs unprotected atomic_t infrastructure.
> 
> I'm fine leaving this choice up to the end user, but I think it makes
> sense to be always-on. If that's no okay, maybe make it default-y for
> arm32, and still let people turn it off if they want?

I'm not really asking for changes.

I'm basically asking for the commit message to do a better job of
explaining this - in years to come, the currently proposed commit
message contains very little information about why this commit exists.

Commit messages need to say what they're doing and why, and not assume
that someone's been to some conference and knows all the inside details
that were discussed there.  It's also best to avoid referencing papers -
conferences and their websites come and go, and links break, at which
point information gets lost.  If it's all properly explained in the
commit message, then it's there forever.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up

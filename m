Date: Tue, 16 May 2017 10:48:18 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20170516154818.GA762@mail.hallyn.com>
References: <20170505232018.28846-1-matt@nmatt.com>
 <20170510212920.7f6bc5e6@alans-desktop>
 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
 <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
 <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com>
 <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Kees Cook <keescook@chromium.org>
Cc: Matt Brown <matt@nmatt.com>, Peter Dolding <oiaohm@gmail.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Kees Cook (keescook@chromium.org):
> On Tue, May 16, 2017 at 5:22 AM, Matt Brown <matt@nmatt.com> wrote:
> > On 05/16/2017 05:01 AM, Peter Dolding wrote:
> >>>
> >>>
> >>> I could see a case being make for CAP_SYS_TTY_CONFIG. However I still
> >>> choose to do with CAP_SYS_ADMIN because it is already in use in the
> >>> TIOCSTI ioctl.
> >>>
> >> Matt Brown don't give me existing behaviour.    CAP_SYS_ADMIN is
> >> overload.   The documentation tells you that you are not to expand it
> >> and you openly admit you have.
> >>
> >
> > This is not true that I'm openly going against what the documentation
> > instructs. The part of the email chain where I show this got removed
> > somehow. Again I will refer to the capabilities man page that you
> > quoted.
> >
> > From http://man7.org/linux/man-pages/man7/capabilities.7.html
> >
> > "Don't choose CAP_SYS_ADMIN if you can possibly avoid it!
> > ...
> > The only new features that should be associated with CAP_SYS_ADMIN are
> > ones that closely match existing uses in that silo."
> >
> > My feature affects the TIOCSTI ioctl. The TIOCSTI ioctl already falls
> > under CAP_SYS_ADMIN, therefore I actually *am* following the
> > documentation.
> 
> CAP_SYS_ADMIN is the right choice here, I agree with Matt: it is
> already in use for TIOCSTI. We can't trivially add new capabilities
> flags (see the various giant threads debating this, the most recently
> that I remember from the kernel lock-down series related to Secure
> Boot).

Consideer that if we use CAP_SYS_TTY_CONFIG now, then any applications
which are currently being given CAP_SYS_ADMIN would need to be updated
with a second capability.  Not acceptable.  Even when we split up
CAP_SYSLOG, we took care to avoid that (by having the original capability
also suffice, so either capability worked).

> >> I fact this usage of TIOCSTI I personally think should require two
> >> capabilities flags set.   CAP_SYS_ADMIN section left as it is at this
> >> stage.   With TIOSCTI stuck behind another capability.
> >>
> >> If you had added a new capability flag you could set file capabilities
> >> on any of the old applications depending on the now secured behaviour.
> 
> If we're adjusting applications, they should be made to avoid TIOSCTI
> completely. This looks to me a lot like the symlink restrictions: yes,
> userspace should be fixed to the do the right thing, but why not
> provide support to userspace to avoid the problem entirely?
> 
> -Kees
> 
> -- 
> Kees Cook
> Pixel Security

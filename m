MIME-Version: 1.0
In-Reply-To: <20170519143344.GA15983@mail.hallyn.com>
References: <20170515215752.4e9f3826@alans-desktop> <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com> <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com> <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170517174113.69d1cbaa@alans-desktop> <1495045540.1619.1.camel@gmail.com>
 <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
 <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com> <20170519143344.GA15983@mail.hallyn.com>
From: Peter Dolding <oiaohm@gmail.com>
Date: Mon, 29 May 2017 20:42:19 +1000
Message-ID: <CANA3KFXVzSXuA4Cocm7fUYE9EOvJX7pW0bsj=cgyUYvScUsXGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 20, 2017 at 12:33 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> On Fri, May 19, 2017 at 12:48:17PM +1000, Peter Dolding wrote:
>> Using cap_sys_admin as fix is like removing car windsheld because
>> vision is being blocked by a rock hitting it.
>
> Nonsense.  If the application has cap_sys_admin then it is less contained and
> more trusted anyway.  If I went to the trouble to run an application in a
> private user namespace (where it can have cap_sys_admin, but not targeted
> at my tty) then it should be more contained.  That's the point of targeted
> capabilities.

The thing that is missed every time is how much is cap_sys_admin.

So you are saying a user namespace has to be set up to contain the defect.

Really no application should have cap_sys_admin.

The theory of capabilities is that security should be broken down into
logical blocks.

So tty stuff should under a tty capabilities.

This one here should not be shoved into cap_sys_admin because can you
show a single case of a general used application performing this
action in the exploit way that is normal behaviour.

The exploits are doing behaviours that have no general place.

Its really simple to shove everything to cap_sys_admin instead of hey
lets look at the exploits how they work and if this should be fairly
blanked banned.  The behaviour that is question is being able push
chars into input stream and have them processed after application has
terminated or after application has switched to background.   That is
not pushing data into another tty.   Pushing data into a different tty
is already restricted to cap_sys_admin.

Personally from my point of view when application terminates or
switches to background  what ever it pushed back into the input buffer
should be junked and maybe a special cap to deal with rare case of
applications that expect this behavour.

Also please remember one of the application using this behaviour of
pushing stuff back to input buffer is csh.  In other words a general
user shell.   This will not be the only application that is general
usage after the change of pushing to cap_sys_admin that would also
have to be pushed to cap_sys_admin because they use TIOCSTI in a way
that the patch will block when the program does not have
cap_sys_admin.   So now you have more applications running as
cap_sys_admin so more security problems.

Peter Dolding.

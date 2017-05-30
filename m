Date: Tue, 30 May 2017 10:52:35 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20170530155235.GA11861@mail.hallyn.com>
References: <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
 <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com>
 <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170517174113.69d1cbaa@alans-desktop>
 <1495045540.1619.1.camel@gmail.com>
 <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
 <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
 <20170519143344.GA15983@mail.hallyn.com>
 <CANA3KFXVzSXuA4Cocm7fUYE9EOvJX7pW0bsj=cgyUYvScUsXGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANA3KFXVzSXuA4Cocm7fUYE9EOvJX7pW0bsj=cgyUYvScUsXGQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Peter Dolding <oiaohm@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Peter Dolding (oiaohm@gmail.com):
> On Sat, May 20, 2017 at 12:33 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > On Fri, May 19, 2017 at 12:48:17PM +1000, Peter Dolding wrote:
> >> Using cap_sys_admin as fix is like removing car windsheld because
> >> vision is being blocked by a rock hitting it.
> >
> > Nonsense.  If the application has cap_sys_admin then it is less contained and
> > more trusted anyway.  If I went to the trouble to run an application in a
> > private user namespace (where it can have cap_sys_admin, but not targeted
> > at my tty) then it should be more contained.  That's the point of targeted
> > capabilities.
> 
> The thing that is missed every time is how much is cap_sys_admin.
> 
> So you are saying a user namespace has to be set up to contain the defect.
> 
> Really no application should have cap_sys_admin.
> 
> The theory of capabilities is that security should be broken down into
> logical blocks.
> 
> So tty stuff should under a tty capabilities.

(last reply on this)

Currently capabilities.7 says

              * employ  the  TIOCSTI ioctl(2) to insert characters into the input queue of a
                terminal other than the caller's controlling terminal;

for CAP_SYS_ADMIN.

So you can create a new CAP_SYS_TIOCSSTI if you like, and offer a patch where
*both* CAP_SYS_ADMIN and CAP_SYS_ADMIN suffice.  Again, see CAP_SYSLOG for a
prior example.

What you may not do is change it so that on an older kernel you must have
CAP_SYS_ADMIN to use TIOCSTI, while on a newer one it does not suffice.

-serge

Date: Fri, 19 May 2017 09:33:44 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20170519143344.GA15983@mail.hallyn.com>
References: <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
 <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com>
 <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170517174113.69d1cbaa@alans-desktop>
 <1495045540.1619.1.camel@gmail.com>
 <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
 <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Peter Dolding <oiaohm@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matt Brown <matt@nmatt.com>, "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 19, 2017 at 12:48:17PM +1000, Peter Dolding wrote:
> Using cap_sys_admin as fix is like removing car windsheld because
> vision is being blocked by a rock hitting it.

Nonsense.  If the application has cap_sys_admin then it is less contained and
more trusted anyway.  If I went to the trouble to run an application in a
private user namespace (where it can have cap_sys_admin, but not targeted
at my tty) then it should be more contained.  That's the point of targeted
capabilities.

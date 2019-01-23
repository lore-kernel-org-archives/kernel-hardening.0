MIME-Version: 1.0
References: <20190123110349.35882-1-keescook@chromium.org> <20190123110349.35882-2-keescook@chromium.org>
 <20190123115829.GA31385@kroah.com> <CAG48ez2vfXkr9dozJiGmze8k49VOXfs=K7M8bv0aQsDDpzrEFQ@mail.gmail.com>
In-Reply-To: <CAG48ez2vfXkr9dozJiGmze8k49VOXfs=K7M8bv0aQsDDpzrEFQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 23 Jan 2019 13:12:26 +0100
Message-ID: <CAKv+Gu-ECKNy+nmnbsetkOg28VR1YkFgnRsu+u9mN4DC_poBwg@mail.gmail.com>
Subject: Re: [PATCH 1/3] treewide: Lift switch variables out of switches
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jann Horn <jannh@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Alexander Popov <alex.popov@linux.com>, xen-devel <xen-devel@lists.xenproject.org>, dri-devel <dri-devel@lists.freedesktop.org>, intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org, Network Development <netdev@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, dev@openvswitch.org, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 23 Jan 2019 at 13:09, Jann Horn <jannh@google.com> wrote:
>
> On Wed, Jan 23, 2019 at 1:04 PM Greg KH <gregkh@linuxfoundation.org> wrot=
e:
> > On Wed, Jan 23, 2019 at 03:03:47AM -0800, Kees Cook wrote:
> > > Variables declared in a switch statement before any case statements
> > > cannot be initialized, so move all instances out of the switches.
> > > After this, future always-initialized stack variables will work
> > > and not throw warnings like this:
> > >
> > > fs/fcntl.c: In function =E2=80=98send_sigio_to_task=E2=80=99:
> > > fs/fcntl.c:738:13: warning: statement will never be executed [-Wswitc=
h-unreachable]
> > >    siginfo_t si;
> > >              ^~
> >
> > That's a pain, so this means we can't have any new variables in { }
> > scope except for at the top of a function?
>
> AFAICS this only applies to switch statements (because they jump to a
> case and don't execute stuff at the start of the block), not blocks
> after if/while/... .
>

I guess that means it may apply to other cases where you do a 'goto'
into the middle of a for() loop, for instance (at the first
iteration), which is also a valid pattern.

Is there any way to tag these assignments so the diagnostic disregards them=
?

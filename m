Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH 1/3] treewide: Lift switch variables out of switches
From: William Kucharski <william.kucharski@oracle.com>
In-Reply-To: <CAG48ez2vfXkr9dozJiGmze8k49VOXfs=K7M8bv0aQsDDpzrEFQ@mail.gmail.com>
Date: Wed, 23 Jan 2019 06:21:44 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <536BB69D-6E93-4E32-8303-16D92E07D8AA@oracle.com>
References: <20190123110349.35882-1-keescook@chromium.org>
 <20190123110349.35882-2-keescook@chromium.org>
 <20190123115829.GA31385@kroah.com>
 <CAG48ez2vfXkr9dozJiGmze8k49VOXfs=K7M8bv0aQsDDpzrEFQ@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Alexander Popov <alex.popov@linux.com>, xen-devel <xen-devel@lists.xenproject.org>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, intel-wired-lan <intel-wired-lan@lists.osuosl.org>, Network Development <netdev@vger.kernel.org>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, dev@openvswitch.org, linux-kbuild@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> On Jan 23, 2019, at 5:09 AM, Jann Horn <jannh@google.com> wrote:
>=20
> AFAICS this only applies to switch statements (because they jump to a
> case and don't execute stuff at the start of the block), not blocks
> after if/while/... .

It bothers me that we are going out of our way to deprecate valid C =
constructs
in favor of placing the declarations elsewhere.

As current compiler warnings would catch any reference before =
initialization
usage anyway, it seems like we are letting a compiler warning rather =
than the
language standard dictate syntax.

Certainly if we want to make it a best practice coding style issue we =
can, and
then an appropriate note explaining why should be added to
Documentation/process/coding-style.rst.=

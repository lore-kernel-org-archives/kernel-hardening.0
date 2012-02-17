Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120217021109.GC6541@outflux.net>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
	<20120216204515.GH20420@outflux.net>
	<20120217002405.GB7746@kroah.com>
	<20120217010624.GA6541@outflux.net>
	<20120217014008.GA18763@kroah.com>
	<20120217021109.GC6541@outflux.net>
Date: Thu, 16 Feb 2012 21:48:38 -0500
Message-ID: <CAEXv5_iRj6zHcKWtV0mgA4i_2u=TB1iQQMYFJAK4r6Ca=pimDA@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [ubuntu-hardened] Add overflow protection to kref
To: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, pageexec@freemail.hu, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, spender@grsecurity.net, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

<snip>

>>
>> I have yet to see a patch, so why are we arguing about this? =A0:)
>>
>> Again, I don't know of any kref overflows that have ever happened, so
>> trying to "protect" this type of thing, seems odd to me.
>
> Well, I think the issue was to protect counting things (which seems to
> be what PaX was after originally), and that kref seemed like the place
> to put it. I'll let David take it further.
>

Patches are forthcoming that will first introduce overflow protection
to kref.  Once that's in place, I'll move a few refcount users from
atomic_t to kref as a reference for other subsystems; statistics-based
users (and others not requiring overflow protection) can continue
using atomic_t.

As Kees said, we just wanted to introduce the idea and get some
general feedback before beginning.  Thanks.

> Thanks,
>
> -Kees
>
> --
> Kees Cook
> ChromeOS Security



--=20
PGP: 6141 5FFD 11AE 9844 153E =A0F268 7C98 7268 6B19 6CC9

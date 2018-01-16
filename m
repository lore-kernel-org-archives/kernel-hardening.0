MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com> <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Jan 2018 14:41:35 -0800
Message-ID: <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="94eb2c05fbaeeed4530562ec6edd"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c05fbaeeed4530562ec6edd
Content-Type: text/plain; charset="UTF-8"

On Jan 16, 2018 14:23, "Dan Williams" <dan.j.williams@intel.com> wrote:


That said, for get_user specifically, can we do something even
cheaper. Dave H. reminds me that any valid user pointer that gets past
the address limit check will have the high bit clear. So instead of
calculating a mask, just unconditionally clear the high bit. It seems
worse case userspace can speculatively leak something that's already
in its address space.


That's not at all true.

The address may be a kernel address. That's the whole point of 'set_fs()'.

That's why we compare against the address limit variable, not against some
constant number.

     Linus

--94eb2c05fbaeeed4530562ec6edd
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Jan 16, 2018 14:23, &quot;Dan Williams&quot; &lt;<a href=3D"ma=
ilto:dan.j.williams@intel.com">dan.j.williams@intel.com</a>&gt; wrote:<br t=
ype=3D"attribution"><blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex"><br>
That said, for get_user specifically, can we do something even<br>
cheaper. Dave H. reminds me that any valid user pointer that gets past<br>
the address limit check will have the high bit clear. So instead of<br>
calculating a mask, just unconditionally clear the high bit. It seems<br>
worse case userspace can speculatively leak something that&#39;s already<br=
>
in its address space.<br></blockquote></div></div></div><div dir=3D"auto"><=
br></div><div dir=3D"auto">That&#39;s not at all true.</div><div dir=3D"aut=
o"><br></div><div dir=3D"auto">The address may be a kernel address. That&#3=
9;s the whole point of &#39;set_fs()&#39;.</div><div dir=3D"auto"><br></div=
><div dir=3D"auto">That&#39;s why we compare against the address limit vari=
able, not against some constant number.</div><div dir=3D"auto"><br></div><d=
iv dir=3D"auto">=C2=A0 =C2=A0 =C2=A0Linus</div><div dir=3D"auto"><div class=
=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"></bloc=
kquote></div></div></div></div>

--94eb2c05fbaeeed4530562ec6edd--

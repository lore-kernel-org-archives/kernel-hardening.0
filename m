Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v6 20/27] x86: Support global stack cookie
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CAJcbSZH3-TVxDsoRLKSuFLU2bHVV9FgDXtUaZFMim3k+4QU8Cg@mail.gmail.com>
Date: Fri, 1 Feb 2019 14:36:24 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <777DD215-A4F5-454F-856F-FFE870F15CDD@amacapital.net>
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-21-thgarnie@chromium.org> <CALCETrVcU_9cczwbfVg6E2cey5B8O9k4j+jYgp0T-CiX9HELtA@mail.gmail.com> <CAJcbSZH3-TVxDsoRLKSuFLU2bHVV9FgDXtUaZFMim3k+4QU8Cg@mail.gmail.com>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Juergen Gross <jgross@suse.com>, Joerg Roedel <jroedel@suse.de>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tim Chen <tim.c.chen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On Feb 1, 2019, at 12:21 PM, Thomas Garnier <thgarnie@chromium.org> wrote:=

>=20
>> On Fri, Feb 1, 2019 at 11:27 AM Andy Lutomirski <luto@kernel.org> wrote:
>>=20
>>> On Thu, Jan 31, 2019 at 11:29 AM Thomas Garnier <thgarnie@chromium.org> w=
rote:
>>>=20
>>> Add an off-by-default configuration option to use a global stack cookie
>>> instead of the default TLS. This configuration option will only be used
>>> with PIE binaries.
>>>=20
>>> For kernel stack cookie, the compiler uses the mcmodel=3Dkernel to switc=
h
>>> between the fs segment to gs segment. A PIE binary does not use
>>> mcmodel=3Dkernel because it can be relocated anywhere, therefore the
>>> compiler will default to the fs segment register. This is fixed on the
>>> latest version of gcc.
>>=20
>> I hate all these gcc-sucks-so-we-hack-it-and-change-nasty-semantics
>> options.  How about just preventing use of both stack protector and
>> PIE unless the version of gcc in use is new enough.
>=20
> So fail the build in this scenario?

Fail the build or use some Kconfig magic to prevent this from being configur=
ed in the first place.

>=20
>>=20
>> Also, does -mstack-protector-guard-reg not solve this?  See
>> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D81708.  Or is there
>> another bug?  Or are you worried about gcc versions that don't have
>> that feature yet?
>=20
> I am worried about gcc versions that don't have this feature, yes.

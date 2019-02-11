Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules
 loading
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190211191059.GR19618@zn.tnic>
Date: Mon, 11 Feb 2019 11:27:03 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <3996E3F9-92D2-4561-84E9-68B43AC60F43@gmail.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-11-rick.p.edgecombe@intel.com>
 <20190211182956.GN19618@zn.tnic>
 <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
 <20190211190108.GP19618@zn.tnic>
 <A671F14F-3E03-4A97-9F54-426533077E0C@gmail.com>
 <20190211191059.GR19618@zn.tnic>
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 11, 2019, at 11:10 AM, Borislav Petkov <bp@alien8.de> wrote:
>=20
> On Mon, Feb 11, 2019 at 11:09:25AM -0800, Nadav Amit wrote:
>> It is just that I find the use of static_cpu_has()/boot_cpu_has() to =
be very
>> inconsistent. I doubt that show_cpuinfo_misc(), =
copy_fpstate_to_sigframe(),
>> or i915_memcpy_init_early() that use static_cpu_has() are any hotter =
than
>> text_poke_early().
>=20
> Would some beefing of the comment over it help?

Is there any comment over static_cpu_has()? ;-)

Anyhow, obviously a comment would be useful.

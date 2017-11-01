Date: Wed, 1 Nov 2017 12:05:55 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20171101120555.yvb65g3wgtxskfh3@lakrids.cambridge.arm.com>
References: <20171026090942.7041-1-mark.rutland@arm.com>
 <77c80381-cf68-aa1a-9112-e057c068eeb6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77c80381-cf68-aa1a-9112-e057c068eeb6@redhat.com>
Subject: [kernel-hardening] Re: [RFC PATCH 0/2] arm64: optional paranoid __{get,put}_user checks
To: Laura Abbott <labbott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 31, 2017 at 04:56:39PM -0700, Laura Abbott wrote:
> On 10/26/2017 02:09 AM, Mark Rutland wrote:
> > In Prague, Kees mentioned that it would be nice to have a mechanism to
> > catch bad __{get,put}_user uses, such as the recent CVE-2017-5123 [1,2]
> > issue with unsafe_put_user() in waitid().
> > 
> > These patches allow an optional access_ok() check to be dropped in
> > arm64's __{get,put}_user() primitives. These will then BUG() if a bad
> > user pointer is passed (which should only happen in the absence of an
> > earlier access_ok() check).

> Turning on the option fails as soon as we hit userspace. On my buildroot
> based environment I get the help text for ld.so (????) and then a message
> about attempting to kill init. 

Ouch. Thanks for the report, and sorry about this.

The problem is that I evaluate the ptr argument twice in
__{get,put}_user(), and this may have side effects.

e.g. when the ELF loader does things like:

  __put_user((elf_addr_t)p, sp++)

... we increment sp twice, and write to the wrong user address, leaving
sp corrupt.

I have an additional patch [1] to fix this, which is in my
arm64/access-ok branch [2].

Thanks,
Mark.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/commit/?h=arm64/access-ok&id=ebb7ff83eb53b8810395d5cf48712a4ae6d678543
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/access-ok

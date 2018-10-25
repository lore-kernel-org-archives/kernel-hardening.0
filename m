Date: Thu, 25 Oct 2018 16:18:35 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC v3 0/3] Rlimit for module space
Message-ID: <20181025141835.GS18839@dhcp22.suse.cz>
References: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
 <CAKv+Gu_AgPv2o4=U0-7pnpgtSufEobnta8oKhhGfCdCxM82B5Q@mail.gmail.com>
 <6b1017c450d163539d2b974657baaaf697f0a138.camel@intel.com>
 <CAKv+Gu-Rk-SQVOQ63L3DkF3=EVik3pHXzpNp5r5TrgDajTM_iQ@mail.gmail.com>
 <20181024150706.jewcclhhh756tupn@linux-8ccs>
 <d7cb6a8c-b7d6-5c82-6721-2b5387da673f@iogearbox.net>
 <d1fec827d028168047eafbac56e8e47d37cf7fb5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1fec827d028168047eafbac56e8e47d37cf7fb5.camel@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "daniel@iogearbox.net" <daniel@iogearbox.net>, "jeyu@kernel.org" <jeyu@kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jannh@google.com" <jannh@google.com>, "keescook@chromium.org" <keescook@chromium.org>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "mingo@redhat.com" <mingo@redhat.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "bp@alien8.de" <bp@alien8.de>, "Hansen, Dave" <dave.hansen@intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "davem@davemloft.net" <davem@davemloft.net>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu 25-10-18 01:01:44, Edgecombe, Rick P wrote:
[...]
> FWIW, cgroups seems like a better solution than rlimit to me too. Maybe you all
> already know, but it looks like the cgroups vmalloc charge is done in the main
> page allocator and counts against the whole kernel memory limit.

I am not sure I understand what you are saying but let me clarify that
vmalloc memory is accounted against memory cgroup associated with the
user context calling vmalloc. All you need to do is to add __GFP_ACCOUNT
to the gfp mask. The only challenge here is the charged memory life
cycle. When does it get deallocated? In the worst case the memory is not
tight to any user context and as such it doesn't get deallocated by
killing all processes which could lead to memcg limit exhaustion.

> A user may want
> to have a higher kernel limit than the module space size, so it seems it isn't
> enough by itself and some new limit would need to be added.

If there is another restriction on this memory then you are right.
-- 
Michal Hocko
SUSE Labs

From: Alexey Budankov <alexey.budankov@linux.intel.com>
Subject: Re: [RFC 0/5] perf: Per PMU access controls (paranoid setting)
References: <20180919122751.12439-1-tvrtko.ursulin@linux.intel.com>
 <alpine.DEB.2.21.1809281151190.2004@nanos.tec.linutronix.de>
 <e89ec139-1a97-803e-343c-76eedf244d65@linux.intel.com>
 <CAG48ez17MOP4hLavskqJDj8KwF=otrNiwV6+cizFPwM_L0k6gA@mail.gmail.com>
 <CAG48ez0Ux6p-Bcu9ymNm_eMpydLm0-DSBYKp4XJRv27XO_QqeA@mail.gmail.com>
Message-ID: <d7ae4c13-262c-a5fb-7e00-cda4b05772ad@linux.intel.com>
Date: Mon, 1 Oct 2018 09:27:07 +0300
MIME-Version: 1.0
In-Reply-To: <CAG48ez0Ux6p-Bcu9ymNm_eMpydLm0-DSBYKp4XJRv27XO_QqeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>
Cc: tvrtko.ursulin@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, tursulin@ursulin.net, kernel list <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, acme@kernel.org, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org, maddy@linux.vnet.ibm.com, Andi Kleen <ak@linux.intel.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello Jann and Kees,

On 29.09.2018 1:02, Jann Horn wrote:
<SNIP>
> Ah, I guess the answer is "0", since you want to see data about what
> other users are doing.
> 
> Does the i915 PMU expose sampling events, counting events, or both?
> The thing about sampling events is that they AFAIK always let the user
> pick arbitrary data to collect - like register contents, or userspace
> stack memory -, and independent of the performance counter being
> monitored, this kind of access should not be permitted to other
> contexts. (But it might be that I misunderstand how perf works - I'm
> not super familiar with its API.)
> 

Currently *core* paranoid >= 1 (per-process mode) prevents simultaneous 
sampling on CPU events (perf record) and reading of uncore HW counters 
(perf stat -I), because uncore counters count system wide and that is 
allowed only when *core* paranoid <= 0.

Uncore counts collected simultaneously with CPU event samples can be 
correlated using timestamps taken from some common system clock e.g. 
CLOCK_MONOTONIC_RAW.

Could it be secure enough to still allow reading of system wide uncore 
HW counters when sampling of CPU events is limited to specific processes 
by *core* paranoid >= 1?

Thanks,
Alexey

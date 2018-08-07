Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 1/2] x86: WARN() when uaccess helpers fault on kernel addresses
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CACT4Y+YJzeTEOASJ8xu5uW_VFYqtoeBpywEC+x0nmFiac_=hJw@mail.gmail.com>
Date: Tue, 7 Aug 2018 07:02:10 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <80A71AAC-89B0-448A-8FF6-FFF1B68270A2@amacapital.net>
References: <20180807012257.20157-1-jannh@google.com> <CACT4Y+YJzeTEOASJ8xu5uW_VFYqtoeBpywEC+x0nmFiac_=hJw@mail.gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On Aug 7, 2018, at 4:04 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
>=20
>> On Tue, Aug 7, 2018 at 3:22 AM, Jann Horn <jannh@google.com> wrote:
>> There have been multiple kernel vulnerabilities that permitted userspace t=
o
>> pass completely unchecked pointers through to userspace accessors:
>>=20
>> - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
>>   access_ok() checks")
>> - the sg/bsg read/write APIs
>> - the infiniband read/write APIs
>>=20
>> These don't happen all that often, but when they do happen, it is hard to=

>> test for them properly; and it is probably also hard to discover them wit=
h
>> fuzzing. Even when an unmapped kernel address is supplied to such buggy
>> code, it just returns -EFAULT instead of doing a proper BUG() or at least=

>> WARN().
>>=20
>> This patch attempts to make such misbehaving code a bit more visible by
>> WARN()ing in the pagefault handler code when a userspace accessor causes
>> #PF on a kernel address and the current context isn't whitelisted.
>=20
> This is not triggerable unless there is a kernel bug, right? I mean
> this won't be a DoS vector? And any case is something to report to
> kernel developers?

Yes. I expect it to help fuzzers, since it will make a uaccess at a bad addr=
ess much more likely to oops.

My old series found one bug when the automated fuzzers fuzzed it. That bug i=
s fixed now.=

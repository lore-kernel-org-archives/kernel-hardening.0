Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: <CAGXu5j+FqZpXURougB_Sd4zmF3bsqsT=m-om5eEM5WCsRX014g@mail.gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DDEC0.9000109@zytor.com> <CAGXu5j+FqZpXURougB_Sd4zmF3bsqsT=m-om5eEM5WCsRX014g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 04 Apr 2013 13:58:06 -0700
Message-ID: <c3d1db06-5196-4828-b0a4-7f6517c7b68a@email.android.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

It seems to me that you are assuming that the attacker is targeting a specific system, but a bot might as well target 256 different systems and see what sticks...

Kees Cook <keescook@chromium.org> wrote:

>On Thu, Apr 4, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/04/2013 01:07 PM, Kees Cook wrote:
>>> However, the benefits of
>>> this feature in certain environments exceed the perceived
>weaknesses[2].
>>
>> Could you clarify?
>
>I would summarize the discussion of KASLR weaknesses into to two
>general observations:
>1- it depends on address location secrecy and leaks are common/easy.
>2- it has low entropy so attack success rates may be high.
>
>For "1", as Julien mentions, remote attacks and attacks from a
>significantly contained process (via seccomp-bpf) minimizes the leak
>exposure. For local attacks, cache timing attacks and other things
>also exist, but the ASLR can be improved to defend against that too.
>So, KASLR is useful on systems that are virtualization hosts,
>providing remote services, or running locally confined processes.
>
>For "2", I think that the comparison to userspace ASLR entropy isn't
>as direct. For userspace, most systems don't tend to have any kind of
>watchdog on segfaulting processes, so a remote attacker could just
>keep trying an attack until they got lucky, in which case low entropy
>is a serious problem. In the case of KASLR, a single attack failure
>means the system goes down, which makes mounting an attack much more
>difficult. I think 8 bits is fine to start with, and I think start
>with a base offset ASLR is a good first step. We can improve things in
>the future.
>
>-Kees
>
>--
>Kees Cook
>Chrome OS Security

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

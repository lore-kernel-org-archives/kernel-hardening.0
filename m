MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171104002430.GN21978@ZenIV.linux.org.uk>
References: <20171103230426.19114-1-labbott@redhat.com> <20171103230426.19114-2-labbott@redhat.com>
 <CAGXu5jJconGeCQbRX9XOpPo__dgDY5zdRtb5G6ce7Wih7SHyiQ@mail.gmail.com> <20171104002430.GN21978@ZenIV.linux.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Nov 2017 18:39:32 -0700
Message-ID: <CAGXu5j+6Q+=2NoXmDJPO3wWGH8nDkHuGujKVgH6fb8cqkHq7WQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 2/2] x86: Allow paranoid __{get,put}_user
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 3, 2017 at 5:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Nov 03, 2017 at 05:14:05PM -0700, Kees Cook wrote:
>> > x86 turns out to be easier since the safe and unsafe paths are mostly
>> > disjoint so we don't have to worry about gcc optimizing out access_ok.
>> > I tweaked the Kconfig to someting a bit more generic.
>> >
>> > The size increase was ~8K in text with a config I tested.
>>
>> Specifically, this feature would have caught the waitid() bug in 4.13
>> immediately.
>
> You mean, as soon as waitid() was given a kernel address.  At which point
> you'd get a shiny way to generate a BUG(), and if something like that
> happened under a mutex - it's even more fun...

Nope, any usage at all would BUG. This would have been immediately noticed. :)

-Kees

-- 
Kees Cook
Pixel Security

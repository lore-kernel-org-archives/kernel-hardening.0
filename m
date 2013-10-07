Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20131005132337.GA4095@dztty>
References: <20131004085911.GA2157@dztty> <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
 <20131004182353.GA2600@dztty> <CALCETrVs2Nd82dpURQxAVetK814bAm8TvnSyA4e=YeTWxTFsmA@mail.gmail.com>
 <20131004191113.GA3916@dztty> <CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
 <20131004192712.GA4334@dztty> <CALCETrUuMRMgJ1OV3-ZRQ5wwzSQsdf9tKY9iKesk1QJPtj6-qw@mail.gmail.com>
 <20131004194142.GA4524@dztty> <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
 <20131005132337.GA4095@dztty>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 7 Oct 2013 14:41:33 -0700
Message-ID: <CALCETrV2YZUQsFiahmcQECF37=sX6EMiEEjwXX_mcuPf-X3-yw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
 opener may access task
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 5, 2013 at 6:23 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Fri, Oct 04, 2013 at 03:17:08PM -0700, Andy Lutomirski wrote:
>>
>> Exactly.  Hence the NAK.
> But Having two LSM Hooks there is really not practical!

It'd doable *if* it turns out that it's the right solution.

But revoke seems much more likely to be simple, comprehensible, and
obviously correct to me.

--Andy

>
> Note to mention some of these redundancy checks...
>
>> >
>> > Is there some mechanism to check what you describe?
>> >
>>
>> No.  You could try to add one, but getting it to be compatible with
>> YAMA might be really messy.
> LSM is limitted in this situation, and it can't work with YAMA, or
> perhaps YAMA will just return -EPERM
>
> So this LSM protections are currently vulnerable too!
>
>
>> Or you could see if destroying and recreating all the inodes on exec
>> or some other revoke-like approach would work.
>>
>> --Andy
>
> --
> Djalal Harouni
> http://opendz.org



-- 
Andy Lutomirski
AMA Capital Management, LLC

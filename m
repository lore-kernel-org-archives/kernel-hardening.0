MIME-Version: 1.0
In-Reply-To: <d3ad5499-02d4-28f0-569a-e28960301097@infradead.org>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-2-git-send-email-tixxdz@gmail.com> <d3ad5499-02d4-28f0-569a-e28960301097@infradead.org>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 27 Nov 2017 22:35:41 +0100
Message-ID: <CAEiveUc37nt2gH7K9-o3iZn1tCLie6r9FOpARxaygm03NNHbjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add request_module_cap()
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Randy,

On Mon, Nov 27, 2017 at 7:48 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> Hi,
>
> Mostly typos/spellos...
>
>
> On 11/27/2017 09:18 AM, Djalal Harouni wrote:
>> Cc: Serge Hallyn <serge@hallyn.com>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Suggested-by: Rusty Russell <rusty@rustcorp.com.au>
>> Suggested-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
>> ---
>>  include/linux/kmod.h      | 65 ++++++++++++++++++++++++++++++++++++++++++-----
>>  include/linux/lsm_hooks.h |  6 ++++-
>>  include/linux/security.h  |  7 +++--
>>  kernel/kmod.c             | 29 ++++++++++++++++-----
>>  security/security.c       |  6 +++--
>>  security/selinux/hooks.c  |  3 ++-
>>  6 files changed, 97 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
>> index 40c89ad..ccd6a1c 100644
>> --- a/include/linux/kmod.h
>> +++ b/include/linux/kmod.h
>> @@ -33,16 +33,67 @@
>
>> +/**
>> + * request_module  Try to load a kernel module
>> + *
>> + * Automatically loads the request module.
>> + *
>> + * @mod...: The module name
>> + */
>
> what are the "..." for?  what do they do here?

Ok, will fix it.

>
>> +#define request_module(mod...) __request_module(true, -1, NULL, mod)
>> +
>> +#define request_module_nowait(mod...) __request_module(false, -1, NULL, mod)
>> +
>> +/**
>> + * request_module_cap  Load kernel module only if the required capability is set
>> + *
[...]
>
>
> --
> ~Randy

Thank you very much for the review, will fix all.


-- 
tixxdz

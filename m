MIME-Version: 1.0
In-Reply-To: <20171128191405.GO729@wotan.suse.de>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-2-git-send-email-tixxdz@gmail.com> <20171128191405.GO729@wotan.suse.de>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Tue, 28 Nov 2017 21:18:38 +0100
Message-ID: <CAEiveUf13RGv1Qf+TOmU+VKtX9_qsO5=r8zsTt6gNdorSDeLqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add request_module_cap()
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Luis,

On Tue, Nov 28, 2017 at 8:14 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Mon, Nov 27, 2017 at 06:18:34PM +0100, Djalal Harouni wrote:
> ...
>
>> After a discussion with Rusty Russell [1], the suggestion was to pass
>> the capability from request_module() to security_kernel_module_request()
>> for 'netdev-%s' modules that need CAP_NET_ADMIN, and after review from
>> Kees Cook [2] and experimenting with the code, the patch now does the
>> following:
>>
>> * Adds the request_module_cap() function.
>> * Updates the __request_module() to take the "required_cap" argument
>>         with the "prefix".
>
> ...
>
>> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
>> ---
>> diff --git a/kernel/kmod.c b/kernel/kmod.c
>> index bc6addd..679d401 100644
>> --- a/kernel/kmod.c
>> +++ b/kernel/kmod.c
>> @@ -139,13 +147,22 @@ int __request_module(bool wait, const char *fmt, ...)
>>       if (!modprobe_path[0])
>>               return 0;
>>
>> +     /*
>> +      * Lets attach the prefix to the module name
>> +      */
>> +     if (prefix != NULL && *prefix != '\0') {
>> +             len += snprintf(module_name, MODULE_NAME_LEN, "%s-", prefix);
>> +             if (len >= MODULE_NAME_LEN)
>> +                     return -ENAMETOOLONG;
>> +     }
>> +
>>       va_start(args, fmt);
>> -     ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
>> +     ret = vsnprintf(module_name + len, MODULE_NAME_LEN - len, fmt, args);
>>       va_end(args);
>> -     if (ret >= MODULE_NAME_LEN)
>> +     if (ret >= MODULE_NAME_LEN - len)
>>               return -ENAMETOOLONG;
>>
>> -     ret = security_kernel_module_request(module_name);
>> +     ret = security_kernel_module_request(module_name, required_cap, prefix);
>>       if (ret)
>>               return ret;
>>
>
> kmod is just a helper to poke userpsace to load a module, that's it.
>
> The old init_module() and newer finit_module() do the real handy work or
> module loading, and both currently only use may_init_module():
>
> static int may_init_module(void)
> {
>         if (!capable(CAP_SYS_MODULE) || modules_disabled)
>                 return -EPERM;
>
>         return 0;
> }
>
> This begs the question:
>
>   o If userspace just tries to just use raw finit_module() do we want similar
>     checks?
>
> Otherwise, correct me if I'm wrong this all seems pointless.
>
> If we want something similar I think we might need to be processing aliases and
> check for the aliases for their desired restrictions on finit_module(),
> otherwise userspace can skip through the checks if the module name does not
> match the alias prefix.
>
> To be clear, aliases are completely ignored today on load_module(), so loading
> 'xfs' with finit_module() will just have the kernel know about 'xfs' not
> 'fs-xfs'.
>
> So we currently do not process aliases in kernel.
>
> I have debugging patches to enable us to process them, but they are just for
> debugging and I've been meaning to send them in for review. I designed them
> only for debugging given last time someone suggested for aliases processing to
> be added, the only use case we found was a pre-optimizations we decided to avoid
> pursuing. Debugging is a good reason to have alias processing in-kernel though.
>
> The pre-optimization we decided to stay away from was to check if the requested
> module via request_module() was already loaded *and* also check if the name passed
> matches any of the existing module aliases for currently loaded modules. Today
> request_module() does not even check if a requested module is already loaded,
> its a stupid loader, it just goes to userspace, and lets userspace figure it
> out. Userspace in turn could check for aliases, but it could lie, or not be up
> to date to do that.
>
> The pre-optmization is a theoretical gain only then, and if userspace had
> proper alias checking it is arguable that it may perform just as equal.
> To help valuate these sorts of things we now have:
>
> tools/testing/selftests/kmod/kmod.sh
>
> So further patches can use and test impact with it.
>
> Anyway -- so aliasing is currently only a debugging consideration, but without
> processing aliases, all this work seems pointless to me as the real loader is
> in finit_module().

These patchset are about module auto-loading which is triggered from
multiple paths in the kernel, the cover letter notes all the
differences between the two operations and why the explicit one and
"modules_disabled=1" is already a pain.

The finit_module() is covered directly by CAP_SYS_MODULE, and for
aliasing I am not sure how it will be related or how userspace will
maintain it, we do not have a use case for it, we want a simple flag.

Thank you!


-- 
tixxdz

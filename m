Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161102204453.GA18842@remoulade>
References: <1478106169-25770-1-git-send-email-vaishali.thakkar@oracle.com> <20161102204453.GA18842@remoulade>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 2 Nov 2016 15:59:25 -0600
Message-ID: <CAGXu5j+go+Fr2OeF-R4BtVHRcBRrC0TaU477J4RwEAe4zDRZ9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH] lib: Harden csum_partial_copy_from_user
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Vaishali Thakkar <vaishali.thakkar@oracle.com>, Mark Rutland <mark.rutland@arm.com>, Al Viro <viro@zeniv.linux.org.uk>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 2, 2016 at 2:44 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Wed, Nov 02, 2016 at 10:32:49PM +0530, Vaishali Thakkar wrote:
>> The routine csum_partial_copy_from_user is same as csum_partial_copy
>> but it copies from user space for the checksumming. In other respects
>> it is identical, and can be used to copy an arbitrarily large buffer
>> from userspace into the kernel. Conceptually this exposes a similar
>> attack surface like copy_from_user. So, to validate the given address
>> we should call check_object_size here.
>
> Thanks for looking at this! I agree that we should be trying lock down these
> homebrew/specialised copy_{to,from}_user routines.

Yes, I'm glad to have more eyes on this. I did notice that these are
almost exclusively used in networking. I'd be curious to see how
noticeable this is on performance (though see my inlining comment
below...)

>
> However...
>
>> @@ -158,6 +159,7 @@ csum_partial_copy_from_user(const void __user *src, void *dst, int len,
>>  {
>>       int missing;
>>
>> +     check_object_size(dst, len, false);
>>       missing = __copy_from_user(dst, src, len);
>
> ... here we're just calling into the architecture-specific __copy_from_user(),
> and I know that both arm64 and x86 have a check_object_size() call in their
> __copy_from_user() implementations.

Another issue here is that csum_partial_copy_from_user() isn't an
inline function, so we lose the performance benefits of ignoring
builtin_cost uses.

> Is that missing on some architectures?

Every architecture is _slightly_ different. Most put the check in
__copy_from_user() so it's correctly caught. (x86 puts them in both
since copy*() calls _copy*(), not __copy*() ... >_<)

> I think we need to figure out where check_object_size() and other checks (e.g.
> kasan_check_size) are expected to live in the hierarchy of uaccess copy
> primitives (and/or if they should also live in {get,put)_user()).

Yes, totally agreed. This is going to be needed for the next step of
usercopy hardening, too. We need to have an arch-specific
__actually_do_the_copy() function that has none of the instrumentation
and is only visible to the usercopy functions. Then we can separate
check logic from the action itself. (Right now we can't pass any
additional information to the check (e.g. whether to make exceptions
to slab whitelisting, etc) because the check is deep in __copy*user().

> I had a plan to try to refactor the generic uaccess code so that we could put
> those checks in one place, but I put that on hold as Al Viro was doing some
> overlapping refactoring of all the uaccess primitives (and I got busy with some
> other work).

Al, is your pass at improving uaccess currently finished, or do you
have more changes coming?

-Kees

-- 
Kees Cook
Nexus Security

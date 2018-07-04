MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <b1bfe507-3dda-fccb-5355-26f6cce9fa6a@suse.cz>
References: <1530646988-25546-1-git-send-email-crecklin@redhat.com> <b1bfe507-3dda-fccb-5355-26f6cce9fa6a@suse.cz>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 4 Jul 2018 09:52:35 -0700
Message-ID: <CAGXu5jJa=jEZmRQa6TYuOFORHs_nYvQAO3Q3Hv5vz4tsHd00nQ@mail.gmail.com>
Subject: Re: [PATCH v7] add param that allows bootline control of hardened usercopy
Content-Type: text/plain; charset="UTF-8"
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Chris von Recklinghausen <crecklin@redhat.com>, Laura Abbott <labbott@redhat.com>, Paolo Abeni <pabeni@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 4, 2018 at 6:43 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 07/03/2018 09:43 PM, Chris von Recklinghausen wrote:
>
> Subject: [PATCH v7] add param that allows bootline control of hardened
> usercopy
>
> s/bootline/boot time/ ?
>
>> v1->v2:
>>       remove CONFIG_HUC_DEFAULT_OFF
>>       default is now enabled, boot param disables
>>       move check to __check_object_size so as to not break optimization of
>>               __builtin_constant_p()
>
> Sorry for late and drive-by suggestion, but I think the change above is
> kind of a waste because there's a function call overhead only to return
> immediately.
>
> Something like this should work and keep benefits of both the built-in
> check and avoiding function call?
>
> static __always_inline void check_object_size(const void *ptr, unsigned
> long n, bool to_user)
> {
>         if (!__builtin_constant_p(n) &&
>                         static_branch_likely(&bypass_usercopy_checks))
>                 __check_object_size(ptr, n, to_user);
> }

This produces less efficient code in the general case, and I'd like to
keep the general case (hardening enabled) as fast as possible.

-Kees

-- 
Kees Cook
Pixel Security

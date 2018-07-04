Subject: Re: [PATCH v7] add param that allows bootline control of hardened
 usercopy
References: <1530646988-25546-1-git-send-email-crecklin@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <b1bfe507-3dda-fccb-5355-26f6cce9fa6a@suse.cz>
Date: Wed, 4 Jul 2018 15:43:39 +0200
MIME-Version: 1.0
In-Reply-To: <1530646988-25546-1-git-send-email-crecklin@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Chris von Recklinghausen <crecklin@redhat.com>, keescook@chromium.org, labbott@redhat.com, pabeni@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 07/03/2018 09:43 PM, Chris von Recklinghausen wrote:

Subject: [PATCH v7] add param that allows bootline control of hardened
usercopy

s/bootline/boot time/ ?

> v1->v2:
> 	remove CONFIG_HUC_DEFAULT_OFF
> 	default is now enabled, boot param disables
> 	move check to __check_object_size so as to not break optimization of
> 		__builtin_constant_p()

Sorry for late and drive-by suggestion, but I think the change above is
kind of a waste because there's a function call overhead only to return
immediately.

Something like this should work and keep benefits of both the built-in
check and avoiding function call?

static __always_inline void check_object_size(const void *ptr, unsigned
long n, bool to_user)
{
        if (!__builtin_constant_p(n) &&
			static_branch_likely(&bypass_usercopy_checks))
                __check_object_size(ptr, n, to_user);
}

Reply-To: kernel-hardening@lists.openwall.com
References: <1455561864-4217-1-git-send-email-labbott@fedoraproject.org>
 <1455561864-4217-2-git-send-email-labbott@fedoraproject.org>
 <56CDBCAB.9040001@redhat.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56CDF1CC.6070903@redhat.com>
Date: Wed, 24 Feb 2016 10:09:16 -0800
MIME-Version: 1.0
In-Reply-To: <56CDBCAB.9040001@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv2 1/4] slub: Drop lock at the end of free_debug_processing
To: Paolo Bonzini <pbonzini@redhat.com>, Laura Abbott <labbott@fedoraproject.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/24/2016 06:22 AM, Paolo Bonzini wrote:
>
>
> On 15/02/2016 19:44, Laura Abbott wrote:
>> -static inline struct kmem_cache_node *free_debug_processing(
>> +static inline int free_debug_processing(
>>   	struct kmem_cache *s, struct page *page,
>>   	void *head, void *tail, int bulk_cnt,
>>   	unsigned long addr, unsigned long *flags) { return NULL; }
>
> I think this has a leftover flags argument.
>
> Paolo
>

Yes, I believe Andrew folded in a patch to the mm tree.

Thanks,
Laura

>> @@ -2648,8 +2646,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>>   	stat(s, FREE_SLOWPATH);
>>
>>   	if (kmem_cache_debug(s) &&
>> -	    !(n = free_debug_processing(s, page, head, tail, cnt,
>> -					addr, &flags)))
>> +	    !free_debug_processing(s, page, head, tail, cnt, addr))

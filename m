Return-Path: <SRS0=PHP+=ZE=lists.openwall.com=kernel-hardening-return-17342-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B91DC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 07:18:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 66F982067B
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 Nov 2019 07:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66F982067B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17342-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22371 invoked by uid 550); 12 Nov 2019 07:18:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22345 invoked from network); 12 Nov 2019 07:18:12 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=am10xx8IfJqOSuDyYTDQaz4P8Dm7qQG6az4OEVbOtdA=;
        b=t1xU/Df3jNezEJGZQHb1rO/6RnRwb5RYBz9TbVHKhPmlj8ei6qZAj1aGQsX8w7/Q0n
         O2YiIy0kZEvDdyjqhA2qW1BzdyFgClXG0/A3BaBPqXBWp/ttC/u6ZqL+Swc5ZWOurLQf
         Me/3zNOuRiz0EfhUG08PvNMzcqsu9NKsKg9EaSCaYZiNDVdOqHMykoc/YZ83mtr6YEY9
         GG4CMWJZEkZCfYmNeIVeQXYCs6YQngIjq0C90P6bgmZqqEUj66O6KauIyt/lN3qy+R+b
         V/hWq2QDBVxV/7eJMbytZ8vDlUHQuEJdZRFYTOL6r/6O1hx4lG/J14RFmkUJFhKaW9Jt
         jw1g==
X-Gm-Message-State: APjAAAXpEYqv4vpeKtImGH11YLI/LdIuzEVYCaTwIcNRdI91qXZGbEnE
	UVOqPCqoDZb3rMEiBwo4108=
X-Google-Smtp-Source: APXvYqz6F1V+0wJw6FjYWnIt+zbcmwGLE/0fVKGtteLeVQJqShnSZrFgTd7XIU7AThhvJJVgUhRZug==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr2576008wml.170.1573543080951;
        Mon, 11 Nov 2019 23:18:00 -0800 (PST)
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches as
 usercopy caches
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: David Windsor <dave@nullcore.net>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Christoph Lameter <cl@linux.com>,
 "David S. Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Christoffer Dall <christoffer.dall@linaro.org>,
 Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>,
 Luis de Bethencourt <luisbg@kernel.org>, Marc Zyngier
 <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>,
 Matthew Garrett <mjg59@google.com>, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, netdev@vger.kernel.org,
 kernel-hardening@lists.openwall.com, Vlastimil Babka <vbabka@suse.cz>,
 Michal Kubecek <mkubecek@suse.cz>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
From: Jiri Slaby <jslaby@suse.cz>
Autocrypt: addr=jslaby@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
Date: Tue, 12 Nov 2019 08:17:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1515636190-24061-10-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 11. 01. 18, 3:02, Kees Cook wrote:
> From: David Windsor <dave@nullcore.net>
> 
> Mark the kmalloc slab caches as entirely whitelisted. These caches
> are frequently used to fulfill kernel allocations that contain data
> to be copied to/from userspace. Internal-only uses are also common,
> but are scattered in the kernel. For now, mark all the kmalloc caches
> as whitelisted.
> 
> This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
> whitelisting code in the last public patch of grsecurity/PaX based on my
> understanding of the code. Changes or omissions from the original code are
> mine and don't reflect the original grsecurity/PaX code.
> 
> Signed-off-by: David Windsor <dave@nullcore.net>
> [kees: merged in moved kmalloc hunks, adjust commit log]
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Christoph Lameter <cl@linux.com>
> ---
>  mm/slab.c        |  3 ++-
>  mm/slab.h        |  3 ++-
>  mm/slab_common.c | 10 ++++++----
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index b9b0df620bb9..dd367fe17a4e 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
...
> @@ -1098,7 +1099,8 @@ void __init setup_kmalloc_cache_index_table(void)
>  static void __init new_kmalloc_cache(int idx, slab_flags_t flags)
>  {
>  	kmalloc_caches[idx] = create_kmalloc_cache(kmalloc_info[idx].name,
> -					kmalloc_info[idx].size, flags);
> +					kmalloc_info[idx].size, flags, 0,
> +					kmalloc_info[idx].size);
>  }
>  
>  /*
> @@ -1139,7 +1141,7 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>  
>  			BUG_ON(!n);
>  			kmalloc_dma_caches[i] = create_kmalloc_cache(n,
> -				size, SLAB_CACHE_DMA | flags);
> +				size, SLAB_CACHE_DMA | flags, 0, 0);

Hi,

was there any (undocumented) reason NOT to mark DMA caches as usercopy?

We are seeing this on s390x:

> usercopy: Kernel memory overwrite attempt detected to SLUB object
'dma-kmalloc-1k' (offset 0, size 11)!
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:99!

See:
https://bugzilla.suse.com/show_bug.cgi?id=1156053

This indeed fixes it:
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1290,7 +1290,8 @@ void __init create_kmalloc_caches(slab_flags_t flags)
                        kmalloc_caches[KMALLOC_DMA][i] =
create_kmalloc_cache(
                                kmalloc_info[i].name[KMALLOC_DMA],
                                kmalloc_info[i].size,
-                               SLAB_CACHE_DMA | flags, 0, 0);
+                               SLAB_CACHE_DMA | flags, 0,
+                               kmalloc_info[i].size);
                }
        }
 #endif


thanks,
-- 
js
suse labs

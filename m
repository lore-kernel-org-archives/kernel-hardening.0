Return-Path: <SRS0=ppwo=D3=lists.openwall.com=kernel-hardening-return-20229-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC16C4363A
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Oct 2020 17:47:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 117F22223C
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Oct 2020 17:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S6p7x4dP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 117F22223C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20229-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21563 invoked by uid 550); 20 Oct 2020 17:46:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11971 invoked from network); 20 Oct 2020 16:56:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=g2w/XqLmU8UpN/I2EdgbT0PljdnADmx25FRLiqYGeBE=;
 b=S6p7x4dPqTVipzDZug+8Izysu59bG2Cq5sm5SDQMs2iLy/NvPXuWu/poQLj+a8gh9fKs
 ZvECjtIkf4ALAS00ZuIRKUZTXf8j7LEYhzX5xibGhXTQf65UJRCGpoi8LnmNgUiG490P
 Fvpx+tP3GOYvslvHOW9vT8RA+5rWktYYfT2d0Liyexb6JPUigzD2ze1cTKVVitNqf3dJ
 uLVXsnS/cK3ctivB07J2746spUchwWjLjDEhpmWA17xxhG7n/eVXjzNTrqiZChCIaT4S
 rfkKFzdwaEVuPqZma1wT3mOvt1NjPjgYmjW49C0V6cITJc8YKWtD3jgl/2MSuQ4DbJCt AQ== 
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
To: Michal Hocko <mhocko@suse.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com,
        linux-hardening@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel@gpiccoli.net, cascardo@canonical.com,
        Alexander Potapenko <glider@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Kees Cook <keescook@chromium.org>
References: <20201019182853.7467-1-gpiccoli@canonical.com>
 <20201020082022.GL27114@dhcp22.suse.cz>
From: Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <c2a0210a-7298-ba31-168c-b488fa69e9a7@oracle.com>
Date: Tue, 20 Oct 2020 09:55:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201020082022.GL27114@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=2 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=2
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1011 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200114

On 10/20/20 1:20 AM, Michal Hocko wrote:
> On Mon 19-10-20 15:28:53, Guilherme G. Piccoli wrote:
> 
> Yes zeroying is quite costly and that is to be expected when the feature
> is enabled. Hugetlb like other allocator users perform their own
> initialization rather than go through __GFP_ZERO path. More on that
> below.
> 
> Could you be more specific about why this is a problem. Hugetlb pool is
> usualy preallocatd once during early boot. 24s for 65GB of 2MB pages
> is non trivial amount of time but it doens't look like a major disaster
> either. If the pool is allocated later it can take much more time due to
> memory fragmentation.
> 
> I definitely do not want to downplay this but I would like to hear about
> the real life examples of the problem.
> 
> [...]
>>
>> Hi everybody, thanks in advance for the review/comments. I'd like to
>> point 2 things related to the implementation:
>>
>> 1) I understand that adding GFP flags is not really welcome by the
>> mm community; I've considered passing that as function parameter but
>> that would be a hacky mess, so I decided to add the flag since it seems
>> this is a fair use of the flag mechanism (to control actions on pages).
>> If anybody has a better/simpler suggestion to implement this, I'm all
>> ears - thanks!
> 
> This has been discussed already (http://lkml.kernel.org/r/20190514143537.10435-4-glider@google.com.
> Previously it has been brought up in SLUB context AFAIR. Your numbers
> are quite clear here but do we really need a gfp flag with all the
> problems we tend to grow in with them?
> 
> One potential way around this specifically for hugetlb would be to use
> __GFP_ZERO when allocating from the allocator and marking the fact in
> the struct page while it is sitting in the pool. Page fault handler
> could then skip the zeroying phase. Not an act of beauty TBH but it
> fits into the existing model of the full control over initialization.
> Btw. it would allow to implement init_on_free semantic as well. I
> haven't implemented the actual two main methods
> hugetlb_test_clear_pre_init_page and hugetlb_mark_pre_init_page because
> I am not entirely sure about the current state of hugetlb struct page in
> the pool. But there should be a lot of room in there (or in tail pages).
> Mike will certainly know much better. But the skeleton of the patch
> would look like something like this (not even compile tested).

Thanks Michal.  I was not involved in the discussions for init_on_alloc,
so was waiting for someone else to comment.

My first though was to also do as you propose.  Skip the clear on page
fault if page was already cleared at allocation time.  Yes, there should
be plenty of room to store this state while huge pages are in the pool.

Of course, users will still see those delays at allocation time pointed
out in the commit message.  I guess that should be expected.  We do have
users which allocate over 1TB of huge pages via sysctl.  Those pages are
used and cleared via page faults, but not necessarily all at the
same time.  If such users would ever set init_on_alloc they would see a
huge delay.  My 'guess' is that such users are unlikely to ever use
init_on_alloc or init_on_free for general performance reasons.
-- 
Mike Kravetz

> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index b5c109703daa..031af7cdf8a7 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -724,7 +724,8 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  			error = PTR_ERR(page);
>  			goto out;
>  		}
> -		clear_huge_page(page, addr, pages_per_huge_page(h));
> +		if (!hugetlb_test_clear_pre_init_page(page))
> +			clear_huge_page(page, addr, pages_per_huge_page(h));
>  		__SetPageUptodate(page);
>  		error = huge_add_to_page_cache(page, mapping, index);
>  		if (unlikely(error)) {
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 67fc6383995b..83cc8abb4d69 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1413,6 +1413,7 @@ static void __free_huge_page(struct page *page)
>  	page->mapping = NULL;
>  	restore_reserve = PagePrivate(page);
>  	ClearPagePrivate(page);
> +	hugetlb_test_clear_pre_init_page(page);
>  
>  	/*
>  	 * If PagePrivate() was set on page, page allocation consumed a
> @@ -1703,6 +1704,7 @@ static struct page *alloc_buddy_huge_page(struct hstate *h,
>  	int order = huge_page_order(h);
>  	struct page *page;
>  	bool alloc_try_hard = true;
> +	bool pre_init = false;
>  
>  	/*
>  	 * By default we always try hard to allocate the page with
> @@ -1718,10 +1720,18 @@ static struct page *alloc_buddy_huge_page(struct hstate *h,
>  		gfp_mask |= __GFP_RETRY_MAYFAIL;
>  	if (nid == NUMA_NO_NODE)
>  		nid = numa_mem_id();
> +
> +	/* prevent from double initialization */
> +	if (want_init_on_alloc(gfp_mask)) {
> +		gfp_mask |= __GFP_ZERO;
> +		pre_init = true;
> +	}
> +
>  	page = __alloc_pages_nodemask(gfp_mask, order, nid, nmask);
> -	if (page)
> +	if (page) {
>  		__count_vm_event(HTLB_BUDDY_PGALLOC);
> -	else
> +		hugetlb_mark_pre_init_page(page);
> +	} else
>  		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
>  
>  	/*
> @@ -4221,6 +4231,7 @@ static vm_fault_t hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  		goto out_release_all;
>  	}
>  
> +	hugetlb_test_clear_pre_init_page(new_page);
>  	copy_user_huge_page(new_page, old_page, address, vma,
>  			    pages_per_huge_page(h));
>  	__SetPageUptodate(new_page);
> @@ -4411,7 +4422,8 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
>  			ret = vmf_error(PTR_ERR(page));
>  			goto out;
>  		}
> -		clear_huge_page(page, address, pages_per_huge_page(h));
> +		if (!hugetlb_test_clear_pre_init_page(page))
> +			clear_huge_page(page, address, pages_per_huge_page(h));
>  		__SetPageUptodate(page);
>  		new_page = true;
>  
> @@ -4709,6 +4721,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
>  		if (IS_ERR(page))
>  			goto out;
>  
> +		hugetlb_test_clear_pre_init_page(page);
>  		ret = copy_huge_page_from_user(page,
>  						(const void __user *) src_addr,
>  						pages_per_huge_page(h), false);
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index eddbe4e56c73..8cc1fc9c4d13 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -525,7 +525,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  	unsigned long flags = qp->flags;
>  	int ret;
>  	bool has_unmovable = false;
> -	pte_t *pte;
> +	pte_t *pte, *mapped_pte;
>  	spinlock_t *ptl;
>  
>  	ptl = pmd_trans_huge_lock(pmd, vma);
> @@ -539,7 +539,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  	if (pmd_trans_unstable(pmd))
>  		return 0;
>  
> -	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	mapped_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
>  	for (; addr != end; pte++, addr += PAGE_SIZE) {
>  		if (!pte_present(*pte))
>  			continue;
> @@ -571,7 +571,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  		} else
>  			break;
>  	}
> -	pte_unmap_unlock(pte - 1, ptl);
> +	pte_unmap_unlock(mapped_pte, ptl);
>  	cond_resched();
>  
>  	if (has_unmovable)
> 

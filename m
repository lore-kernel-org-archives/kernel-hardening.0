Return-Path: <SRS0=GI1D=WZ=lists.openwall.com=kernel-hardening-return-16828-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12F4C3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 16:15:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BC5902189D
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 16:15:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ByTqi19b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC5902189D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16828-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14206 invoked by uid 550); 29 Aug 2019 16:15:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14171 invoked from network); 29 Aug 2019 16:15:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Szvq847dDpWg4DATPvTxScYZpekJZ5L13FYPdVzObVQ=;
        b=ByTqi19bVKsCTeyUO9bvA2dpHjEA79ypwTv0Iygwog7IDdsC6KsuUOVwC6XWOJ0unq
         uxj5NAB2yg0uPrMqhkPkveUPbFxm4c+s2KPsXMHgpww8T9pEpc4M9Iwc4sL5VeNGWSF0
         GJmfPBJLDjW5OhK0SdzgHV25DOT6wGcENMIsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Szvq847dDpWg4DATPvTxScYZpekJZ5L13FYPdVzObVQ=;
        b=Rc7md53B1q+xj/1TFmVzkrO6cnjqrPVD7WN0gDRxBUo57/MJwORuHriV2SpDUVfhS4
         /+IZyK7VVunsg8Cq2+FeJLe0JrcV0gNQcN/yy/QWV7HVwUHS7fAnntFoKe1Jee89hkDJ
         hl3bluFKPRJd9UYIMdr5L4rt6U7CdkrI2q5S6ObXWx/VxJNpHDOZa7hbPqKjvrNTRpDT
         XU0QcgWbOoSnDfN8NvO29NIL7VWzbiAADQBnBI15lTKfTTtq6LPKB6vjtUw3PDZWpslY
         h0OP01l9xT05P4DOV7LENWxv7WPMbyBJMpVrA+UqT5VYa1fTVqYF87v7eAaz+850jgHb
         mQmg==
X-Gm-Message-State: APjAAAXivwIoIyXrlvmYd/8aY6xB2U36HjgnxbMWvCrLhdVbWGNyEjLe
	qu25X7BX676Kq4j+01iHWQlsKQ==
X-Google-Smtp-Source: APXvYqySDhlA1gi35UhNfMvKIL9EA+HbT30vnjkpVccc/ySUcyeTOWq92b5sIwFGcCrvh2IT+Ymq/w==
X-Received: by 2002:a63:58c:: with SMTP id 134mr9549282pgf.106.1567095338237;
        Thu, 29 Aug 2019 09:15:38 -0700 (PDT)
Date: Thu, 29 Aug 2019 09:15:36 -0700
From: Kees Cook <keescook@chromium.org>
To: Jason Yan <yanaijie@huawei.com>
Cc: kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org
Subject: Re: CONFIG_HARDENED_USERCOPY
Message-ID: <201908290914.F0F929EA@keescook>
References: <6e02a518-fea9-19fe-dca7-0323a576750d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e02a518-fea9-19fe-dca7-0323a576750d@huawei.com>

On Thu, Aug 29, 2019 at 08:42:30PM +0800, Jason Yan wrote:
> We found an issue of kernel bug related to HARDENED_USERCOPY.
> When copying an IO buffer to userspace, HARDENED_USERCOPY thought it is
> illegal to copy this buffer. Actually this is because this IO buffer was
> merged from two bio vectors, and the two bio vectors buffer was allocated
> with kmalloc() in the filesystem layer.

Ew. I thought the FS layer was always using page_alloc?

> The block layer __blk_segment_map_sg() do the merge if two bio vectors is
> continuous in physical.
> 
> /* Default implementation of BIOVEC_PHYS_MERGEABLE */
> #define __BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
> 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
> 
> After the merge, driver do not know the buffer is consist of two slab
> objects. It copies this buffer at once with the total length.
> Obviously this cannot through the check of HARDENED_USERCOPY.
> 
> So how can we do in this situation?
> 1.Shutdown HARDENED_USERCOPY ?
> 2.Tell filesystems not to use kmalloc to send IOs down?
> 3.Tell the driver to use _copy_to_user instead of copy_to_user ?

What about disallowing merges across slab allocations?

-Kees

> 
> Thoughts? suggestions?
> 
> crash> bt
> PID: 38986  TASK: ffff803dc0b9ae80  CPU: 12  COMMAND: "scsi_init_0"
>  #0 [ffff00001cbfb470] machine_kexec at ffff0000080a2724
>  #1 [ffff00001cbfb4d0] __crash_kexec at ffff0000081b7b74
>  #2 [ffff00001cbfb660] panic at ffff0000080ee8cc
>  #3 [ffff00001cbfb740] die at ffff00000808f6ac
>  #4 [ffff00001cbfb790] bug_handler at ffff00000808f744
>  #5 [ffff00001cbfb7c0] brk_handler at ffff000008085d1c
>  #6 [ffff00001cbfb7e0] do_debug_exception at ffff000008081194
>  #7 [ffff00001cbfb9f0] el1_dbg at ffff00000808332c
>      PC: ffff0000083395d8  [usercopy_abort+136]
>      LR: ffff0000083395d8  [usercopy_abort+136]
>      SP: ffff00001cbfba00  PSTATE: 40000005
>     X29: ffff00001cbfba10  X28: 0000000000000000  X27: ffff80244802e000
>     X26: 0000000000000400  X25: 0000000000000000  X24: ffff80380625fa00
>     X23: 0000000000000001  X22: 0000000000000400  X21: 0000000000000000
>     X20: ffff000008c95698  X19: ffff000008c99970  X18: ffffffffffffffff
>     X17: 0000000000000000  X16: 0000000000000000  X15: 0000000000000001
>     X14: ffff000008aa7e48  X13: 0000000000000000  X12: 0000000000000000
>     X11: 00000000ffffffff  X10: 0000000000000010   X9: ffff000008ef1018
>      X8: 0000000000000854   X7: 0000000000000003   X6: ffff803ffbf8b3c8
>      X5: ffff803ffbf8b3c8   X4: 0000000000000000   X3: ffff803ffbf93b08
>      X2: 902990500743b200   X1: 0000000000000000   X0: 0000000000000067
>  #8 [ffff00001cbfba10] usercopy_abort at ffff0000083395d4
>  #9 [ffff00001cbfba50] __check_heap_object at ffff000008310910
> #10 [ffff00001cbfba80] __check_object_size at ffff000008339770
> #11 [ffff00001cbfbac0] vsc_xfer_data at ffff000000ca9bac [vsc]
> #12 [ffff00001cbfbb60] vsc_scsi_cmd_data at ffff000000cab368 [vsc]
> #13 [ffff00001cbfbc00] vsc_get_msg_unlock at ffff000000cad198 [vsc]
> #14 [ffff00001cbfbc90] vsc_get_msg at ffff000000cad6f0 [vsc]
> #15 [ffff00001cbfbcd0] vsc_dev_read at ffff000000ca2688 [vsc]
> #16 [ffff00001cbfbd00] __vfs_read at ffff00000833f234
> #17 [ffff00001cbfbdb0] vfs_read at ffff00000833f3f0
> #18 [ffff00001cbfbdf0] ksys_read at ffff00000833fb50
> #19 [ffff00001cbfbe40] __arm64_sys_read at ffff00000833fbe0
> #20 [ffff00001cbfbe60] el0_svc_common at ffff000008097b54
> #21 [ffff00001cbfbea0] el0_svc_handler at ffff000008097c44
> #22 [ffff00001cbfbff0] el0_svc at ffff000008084144
>      PC: 000040003a653548   LR: 000040003a653530   SP: 00004001f1087ad0
>     X29: 00004001f1087ad0  X28: 000040002b1f7000  X27: 0000400034c5b958
>     X26: 00004001042f7d58  X25: 0000000000000004  X24: 0000000000000000
>     X23: 00004001f1087c38  X22: 00004001f1087c58  X21: 00004001f1087d38
>     X20: 0000000000000400  X19: 000000000000001c  X18: 0000000000000000
>     X17: 000040003a6534d8  X16: 000040002b1ecc48  X15: 0000000000001268
>     X14: 000000000000003b  X13: 0000000000000400  X12: 00004000f4291000
>     X11: 0000000000000400  X10: 0000000100000010   X9: 0000001000000002
>      X8: 000000000000003f   X7: 004cf56500000000   X6: 0000000000000000
>      X5: 00004001f1088ac0   X4: 00000000ffffffbb   X3: 0000000000000000
>      X2: 0000000000000400   X1: 00004001f1087d38   X0: 000000000000001c
>     ORIG_X0: 000000000000001c  SYSCALLNO: 3f  PSTATE: 80000000
> crash>
> 
>   sc_data_direction = DMA_TO_DEVICE,
>   cmnd = 0xffff802187d69d38 "*",
>   sdb = {
>     table = {
>       sgl = 0xffff80380625fa00,
>       nents = 1,
>       orig_nents = 2
>     },
>     length = 1024,
>     resid = 0
>   },
> 
> crash> struct bio_vec 0xffff80217ce4a2b0
> struct bio_vec {
>   bv_page = 0xffff7e0091200b80,
>   bv_len = 512,
>   bv_offset = 0
> }
> crash> struct bio_vec 0xffff80217ce4a8b0
> struct bio_vec {
>   bv_page = 0xffff7e0091200b80,
>   bv_len = 512,
>   bv_offset = 512
> }
> 
> 

-- 
Kees Cook

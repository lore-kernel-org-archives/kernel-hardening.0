Return-Path: <SRS0=4IEz=74=lists.openwall.com=kernel-hardening-return-18976-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C19C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:35:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C291F206D7
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C291F206D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18976-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28528 invoked by uid 550); 15 Jun 2020 09:35:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19632 invoked from network); 15 Jun 2020 08:29:24 -0000
Subject: Re: [PATCH] erofs: Eliminate usage of uninitialized_var() macro
To: Gao Xiang <hsiangkao@redhat.com>, Jason Yan <yanaijie@huawei.com>
CC: Kees Cook <keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<xiang@kernel.org>, <linux-erofs@lists.ozlabs.org>
References: <20200615040141.3627746-1-yanaijie@huawei.com>
 <20200615072521.GA25317@xiangao.remote.csb>
 <783fe4f9-fb1f-7f5e-c900-7e30d5c85222@huawei.com>
 <20200615080714.GB25317@xiangao.remote.csb>
From: Chao Yu <yuchao0@huawei.com>
Message-ID: <4319ff76-c61f-e266-354f-83526207c767@huawei.com>
Date: Mon, 15 Jun 2020 16:29:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200615080714.GB25317@xiangao.remote.csb>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected

On 2020/6/15 16:07, Gao Xiang wrote:
> On Mon, Jun 15, 2020 at 03:43:09PM +0800, Jason Yan wrote:
>>
>>
>> �?2020/6/15 15:25, Gao Xiang 写道:
>>> Hi Jason,
>>>
>>> On Mon, Jun 15, 2020 at 12:01:41PM +0800, Jason Yan wrote:
>>>> This is an effort to eliminate the uninitialized_var() macro[1].
>>>>
>>>> The use of this macro is the wrong solution because it forces off ANY
>>>> analysis by the compiler for a given variable. It even masks "unused
>>>> variable" warnings.
>>>>
>>>> Quoted from Linus[2]:
>>>>
>>>> "It's a horrible thing to use, in that it adds extra cruft to the
>>>> source code, and then shuts up a compiler warning (even the _reliable_
>>>> warnings from gcc)."
>>>>
>>>> The gcc option "-Wmaybe-uninitialized" has been disabled and this change
>>>> will not produce any warnnings even with "make W=1".
>>>>
>>>> [1] https://github.com/KSPP/linux/issues/81
>>>> [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>>>>
>>>> Cc: Kees Cook <keescook@chromium.org>
>>>> Cc: Chao Yu <yuchao0@huawei.com>
>>>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>>>> ---
>>>
>>> I'm fine with the patch since "-Wmaybe-uninitialized" has been disabled and
>>> I've also asked Kees for it in private previously.
>>>
>>> I still remembered that Kees sent out a treewide patch. Sorry about that
>>> I don't catch up it... But what is wrong with the original patchset?
>>>
>>
>> Yes, Kees has remind me of that and I will let him handle it. So you can
>> ignore this patch.
> 
> Okay, I was just wondering if this part should be send out via EROFS tree
> for this cycle. However if there was an automatic generated patch by Kees,
> I think perhaps Linus could pick them out directly. But anyway, both ways
> are fine with me. ;) Ping me when needed.

Either way is okay to me.

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>>
>> Thanks,
>> Jason
>>
>>> Thanks,
>>> Gao Xiang
>>>
>>>
>>> .
>>>
>>
> 
> .
> 

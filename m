Return-Path: <SRS0=ijwD=4O=lists.openwall.com=kernel-hardening-return-17957-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EB3C4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 08:27:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8463621556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 08:27:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8463621556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17957-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26338 invoked by uid 550); 26 Feb 2020 08:27:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26588 invoked from network); 26 Feb 2020 06:38:50 -0000
Subject: Re: [PATCH v5 8/8] powerpc/mm: Disable set_memory() routines when
 strict RWX isn't enabled
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: jniethe5@gmail.com, christophe.leroy@c-s.fr, joel@jms.id.au,
        mpe@ellerman.id.au, dja@axtens.net, npiggin@gmail.com,
        kernel-hardening@lists.openwall.com
References: <20200226063551.65363-1-ruscur@russell.cc>
 <20200226063551.65363-9-ruscur@russell.cc>
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Wed, 26 Feb 2020 17:38:29 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226063551.65363-9-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022606-0008-0000-0000-000003567CAB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022606-0009-0000-0000-00004A779A5A
Message-Id: <c560b6bb-1a42-bf50-5122-7912771e1481@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_01:2020-02-25,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=922 phishscore=0
 bulkscore=0 suspectscore=0 clxscore=1011 adultscore=0 lowpriorityscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260047

On 26/2/20 5:35 pm, Russell Currey wrote:
> There are a couple of reasons that the set_memory() functions are
> problematic when STRICT_KERNEL_RWX isn't enabled:
> 
>   - The linear mapping is a different size and apply_to_page_range()
> 	may modify a giant section, breaking everything
>   - patch_instruction() doesn't know to work around a page being marked
>   	RO, and will subsequently crash
> 
> The latter can be replicated by building a kernel with the set_memory()
> patches but with STRICT_KERNEL_RWX off and running ftracetest.
> 
> Reported-by: Jordan Niethe <jniethe5@gmail.com>
> Signed-off-by: Russell Currey <ruscur@russell.cc>

Can we squash this in earlier in the series for the sake of bisectability?

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited


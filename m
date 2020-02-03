Return-Path: <SRS0=+5fr=3X=lists.openwall.com=kernel-hardening-return-17655-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BA7C35247
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 17:17:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EE88720838
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 17:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="WHCq/xca"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE88720838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amd.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17655-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8003 invoked by uid 550); 3 Feb 2020 17:16:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7968 invoked from network); 3 Feb 2020 17:16:54 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiffTm8WM5G0SEFInh4n3wWxlwEU81QHOexvi5qVkhRBQ+hWStNE5A4Y8EvMwi8xIr6jfvKLP91QJ6fY5zoCem2sG7hT/uPCQRdXchBGxq5ZsmfH68kWg62JRiFguJWKFzgEOeFSYem1g14A0sY+WN8wi4y1UL3J41DhEX2CjENrt/D8lbUwt7as4fzr2O5rrostVExPqANamJYvKNYEJCSfbfcwpU7kSGRpvjP47UL9ki9I0WmOF56M07FiXDmIOZKBUN9PDvUPJVCZdMOfKD8ZAU+LH4CNidFiTxS2ko02FDHkuy5ieYg4ZcCoV+SEmzw4p9cXT7XEbmHiccKCJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP5YxPaUnw/mmqtfzj0P0CXrZvdxGSpEZaMB3tAG10A=;
 b=AcTXpNj1QuhsqYGHf/RyBzcuaLi1KlI95QmHXbCMT3xCTPTGadYup9PHlCUfJrjbRIQfad1czcBm32ld9M3LwumoUh1geEVX8Vn28KDRQ+EfU8GVf2kc5KZnMw3cMtcS/LllaxqNbq+JIJiIXPgqpNGkDYAKcQvJMW/M0ugkVn5CVrMDW46fAy5wvheZTOpR8DkUMssS94/NIT1dWNXf5Sc5B1VOlI/OPZ/72ElVoSqbIXLgmL6/oM3Q62uOa/pb8u3mYJMFAnQY8kM7vOoZZ0UHOPk3qcRv9mowKPCRW7iRmxCM1pjpYYFzYCLOkXhs3kxd4T9bd6hTmux+55kxAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP5YxPaUnw/mmqtfzj0P0CXrZvdxGSpEZaMB3tAG10A=;
 b=WHCq/xca27D/otRxSfpGL5qvAiUSlpmn37kf0Ugfx9NXVPd3L5Urz6xzQp6rDLtCKYVcW/X04TFhAokWYKjoS8gHqg3Xlhxxyj8mT4brUTISNYdXSpVhXXcO2gj8FGgWfi5/TquwaZFHOvjeVWwUkbzFMqiH2nvt5XslMGxInBM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
Subject: Re: [PATCH v2] drm/radeon: have the callers of set_memory_*() check
 the return value
To: Tianlin Li <tli@digitalocean.com>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, Alex Deucher <alexander.deucher@amd.com>,
 David1.Zhou@amd.com, David Airlie <airlied@linux.ie>,
 Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20200203161827.768-1-tli@digitalocean.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <6e5a18f6-b7f6-c401-c845-fe24b183f348@amd.com>
Date: Mon, 3 Feb 2020 18:16:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200203161827.768-1-tli@digitalocean.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR05CA0086.eurprd05.prod.outlook.com
 (2603:10a6:208:136::26) To DM5PR12MB1705.namprd12.prod.outlook.com
 (2603:10b6:3:10c::22)
MIME-Version: 1.0
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b603d2b-343a-4008-4cbe-08d7a8ccd4ba
X-MS-TrafficTypeDiagnostic: DM5PR12MB1209:|DM5PR12MB1209:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DM5PR12MB120964F1725658F3FC14CD5083000@DM5PR12MB1209.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0302D4F392
X-Forefront-Antispam-Report:
	SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(189003)(199004)(2616005)(66946007)(66556008)(31696002)(66476007)(2906002)(6486002)(36756003)(31686004)(4326008)(86362001)(66574012)(81156014)(8676002)(81166006)(8936002)(54906003)(6666004)(316002)(52116002)(45080400002)(16526019)(966005)(186003)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1209;H:DM5PR12MB1705.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8NPey4ko1r9VwUhulrVFZ+tTb1Ogma/BQWyxeEm2HuPkjLm/3iGX4W1MeBukMJ/r+3lyB4X1CEVtT31K7drrmR2rEGRElGexQHotzKqLQ6EbXmA4djERNJvw/khJl5bVrz1dQswL9hGcfeYLPttPiXN4dSB6ckZGUH7mIX1oEWrTAwBlUCrDyQTP/1JIaNwyRrDkzgRR/B+xttyoFkbmke0Aeq3WRzRzz9ukGK4xCFWFt6clxTxE+ujxh+42L4iG0DZ+SHVRbmJZvMn/LZA1wxlWfx39fFEaWZjNu903cm+Af0x+QaESmZVQ5b7LbyyCB3O3UdohCexoIiiPu6OioeoPCJues1FILGmX6vpJlNCFiC5AFaYzCd3b21uuFBWM3gGRUTLBtGKbpJKfKCR0r+iBSRnHW3vLO700HLw6FXmhvtAArP8LCu/WkKlypmxh+HyBRB0GVuLQZrq89SYOru7+pQT3iHqJC6HCX55eVzR6nCS5WLn/62N+juKJVfDA2uuf+CBGK0g1U0XSGzddpA==
X-MS-Exchange-AntiSpam-MessageData:
	mHrqjViZGqH+NG9fAuMDu9GXI3Y07SDcoW6HFuAH1+m4lXCgHK7Z57Bo7QrDKMZcURabr65XhmsEPZDTbsrp2JPTgT0Gt0p6IGuNHr9ZL38Atpe1wdNgfjhGfyNwgVFXWYlPaFThA+pSoivY8pjZ/Yi9afDNnHfyIGPTzpx4X9klHTjdWX60DnBaYlc6gaWtIxt6ShVbdL1GUo4J7SkhbA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b603d2b-343a-4008-4cbe-08d7a8ccd4ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 17:16:39.3232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39B9R42sPSaCYxjZvJdYiFHcNyyW0ay7OlE8NrM4loHqbD1HF08+h71L+oeNX1Ns
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1209

Am 03.02.20 um 17:18 schrieb Tianlin Li:
> Right now several architectures allow their set_memory_*() family of
> functions to fail,

Oh, that is a detail I previously didn't recognized. Which architectures 
are that?

Cause the RS400/480, RS690 and RS740 which are affected by this are 
integrated in the south-bridge.

>   but callers may not be checking the return values.
> If set_memory_*() returns with an error, call-site assumptions may be
> infact wrong to assume that it would either succeed or not succeed at
> all. Ideally, the failure of set_memory_*() should be passed up the
> call stack, and callers should examine the failure and deal with it.
>
> Need to fix the callers and add the __must_check attribute. They also
> may not provide any level of atomicity, in the sense that the memory
> protections may be left incomplete on failure. This issue likely has a
> few steps on effects architectures:
> 1)Have all callers of set_memory_*() helpers check the return value.
> 2)Add __must_check to all set_memory_*() helpers so that new uses do
> not ignore the return value.
> 3)Add atomicity to the calls so that the memory protections aren't left
> in a partial state.
>
> This series is part of step 1. Make drm/radeon check the return value of
> set_memory_*().
>
> Signed-off-by: Tianlin Li <tli@digitalocean.com>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
> v2:
> The hardware is too old to be tested on and the code cannot be simply
> removed from the kernel, so this is the solution for the short term.
> - Just print an error when something goes wrong
> - Remove patch 2.
> v1:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F20200107192555.20606-1-tli%40digitalocean.com%2F&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7Cba2176d2ca834214e6b108d7a8c4bb1d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163435227030235&amp;sdata=mDhUEi3vmxahjsdrZOr83OEIWNBHefO8lkXST%2FW32CE%3D&amp;reserved=0
> ---
>   drivers/gpu/drm/radeon/radeon_gart.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
> index f178ba321715..a2cc864aa08d 100644
> --- a/drivers/gpu/drm/radeon/radeon_gart.c
> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> @@ -80,8 +80,9 @@ int radeon_gart_table_ram_alloc(struct radeon_device *rdev)
>   #ifdef CONFIG_X86
>   	if (rdev->family == CHIP_RS400 || rdev->family == CHIP_RS480 ||
>   	    rdev->family == CHIP_RS690 || rdev->family == CHIP_RS740) {
> -		set_memory_uc((unsigned long)ptr,
> -			      rdev->gart.table_size >> PAGE_SHIFT);
> +		if (set_memory_uc((unsigned long)ptr,
> +			      rdev->gart.table_size >> PAGE_SHIFT))
> +			DRM_ERROR("set_memory_uc failed.\n");
>   	}
>   #endif
>   	rdev->gart.ptr = ptr;
> @@ -106,8 +107,9 @@ void radeon_gart_table_ram_free(struct radeon_device *rdev)
>   #ifdef CONFIG_X86
>   	if (rdev->family == CHIP_RS400 || rdev->family == CHIP_RS480 ||
>   	    rdev->family == CHIP_RS690 || rdev->family == CHIP_RS740) {
> -		set_memory_wb((unsigned long)rdev->gart.ptr,
> -			      rdev->gart.table_size >> PAGE_SHIFT);
> +		if (set_memory_wb((unsigned long)rdev->gart.ptr,
> +			      rdev->gart.table_size >> PAGE_SHIFT))
> +			DRM_ERROR("set_memory_wb failed.\n");
>   	}
>   #endif
>   	pci_free_consistent(rdev->pdev, rdev->gart.table_size,


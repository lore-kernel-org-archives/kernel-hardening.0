Return-Path: <SRS0=x10f=26=lists.openwall.com=kernel-hardening-return-17555-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDE6C32771
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jan 2020 10:15:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9F5052072A
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jan 2020 10:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="PX7nYBXX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F5052072A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amd.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17555-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26427 invoked by uid 550); 9 Jan 2020 10:15:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26391 invoked from network); 9 Jan 2020 10:15:32 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+e3p28+WVHci44bvpHJhQdor9Ty/qIJvf+qo+x9Yg9H5f9wCZOrw7+c5PTx0i8coBH8hGuqA9Klf8mxJoYRFVQaDoncTAujcFxo86HdmTz6E/U7wKsqgYzcD3bHVhVclX3AgoHzIqTFMkpyfjbjiqa/SLtBupAyw7CXxAGbjkovV7Du76i/rWjMKJo7LBjzLkMGY9SDKuChTZr6C+Cjozh7csQNmxE8yoHW6Tof+oYfnXpWsSwkfBbQEBBZTIiTDtgO3GHyCtpId1NaqihvRWS6eUX/iL7OLKay2jvzcQC+fs8bhhXiDjgUv6FQ858HK5OTLrVhJJm1qmc/fK/Y7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZufGPYmcOmszYCmgdpWsaFPzjSAvVqnk7hN6BpWaBcQ=;
 b=B5ymCSlfThSnH95dc0zgbRE8LCHDKIYbzojWBm6T1ORFHYeFZFY13wWWDvSWjxaasc1MNPIOOrehExtcApWUrdJ+IfeSeqv+siNG2T/sq5OS6IKuwAIkBMqRiLlauL4y3nr8rWfBDndwUB5ziSTWkIZLA5TQB8d8Kp4PquyYa17TVuwPSekvQFBh7QSaOydMl88uenNxTyVJZ2yjV8NyJL+d68bAmNtiATY9Nr2z9E4oLhn0POL4sexFVnqSIarRpe8r4X89lRl97lCF2LwIjeCW8ar2ru9lJkYocQIqpyx7NYsZTSsVP+lHgK4m77yHJwtzpsmekIXjRJPpyde8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZufGPYmcOmszYCmgdpWsaFPzjSAvVqnk7hN6BpWaBcQ=;
 b=PX7nYBXXoXytJqJUES1UwWgQueqXgvMXWf1FG5dY095G5R3OAAqHdo8Eq5BqquCCywYxfZq36jG2mt/nyTKAtO1Ni5gYd/1q73huLwhsTK/p5ClRcU1IkiSs2+LyUPatCtNw0sQ2nau7nU0IDJuwR4Bh5phHEYBriXts3KYrniE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
Subject: Re: [PATCH 0/2] drm/radeon: have the callers of set_memory_*() check
 the return value
To: Alex Deucher <alexdeucher@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, David Airlie <airlied@linux.ie>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>,
 amd-gfx list <amd-gfx@lists.freedesktop.org>,
 Tianlin Li <tli@digitalocean.com>,
 Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
 Alex Deucher <alexander.deucher@amd.com>
References: <20200107192555.20606-1-tli@digitalocean.com>
 <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>
 <202001080936.A36005F1@keescook>
 <CADnq5_NLS=CuHD39utCTnTVsY_izuTPXFfsew6TpMjovgFoT5g@mail.gmail.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <a2919283-f5aa-43b2-9186-6c41315458c4@amd.com>
Date: Thu, 9 Jan 2020 11:15:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CADnq5_NLS=CuHD39utCTnTVsY_izuTPXFfsew6TpMjovgFoT5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0052.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::32) To BN6PR12MB1699.namprd12.prod.outlook.com
 (2603:10b6:404:ff::20)
MIME-Version: 1.0
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3be78018-8481-4f29-b86b-08d794ecd31d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1314:|BN6PR12MB1314:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BN6PR12MB1314412E1CAB5A06082F898983390@BN6PR12MB1314.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report:
	SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(86362001)(66574012)(8676002)(53546011)(6666004)(31686004)(4326008)(66476007)(66556008)(66946007)(81156014)(52116002)(5660300002)(8936002)(36756003)(81166006)(16526019)(316002)(54906003)(110136005)(31696002)(186003)(45080400002)(2616005)(966005)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR12MB1314;H:BN6PR12MB1699.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	slXjqOyQixByrGfVPPtTHwUZsPkfKWrGO7E74cSId618zy3+IZ87lAe766Bx934u1YhuadtT0taJGp72t5RweH77evdNQ4kM8m1hRzy5g09utXKt//UP7Ow58s3R2NGaBYr42PKKsEDUj7QG92hH6Cr0CJUf/1vtcIljEXcgyoQrFUo7eMeouzD1WeKkEXYJ4xiePPPFDAoFqdu6UssIyYHUZM95qjhgHl3IcpATuxBolaWOQ2l2BpaszCUQ+kPcZYz74RHi3EqTa+hYVyMKw4Dt1A+2LWJFtloQH2I03AcgBC+Z4NtQqtM3vm0DLsquqLCak6EEAcTq7+jxoenZiTsxphCSOTKP3FZeUgc3vMjcxtjGYbadRA3HaUmI2+VO2U+q6bLYOmKuVPjZs3tYaAnz8fQEg6dqHnrssONQ3lNgMjVCa5/67QtD3l6wdOilvxO+t+Mx2YRIHFrscRpGA4W8NzUJdGNHee0Nss6OLGc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be78018-8481-4f29-b86b-08d794ecd31d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 10:15:17.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFraTC4Nw5P53Fc2etWK/nG3aauXz+n0Loo6cwQiHI9sjuMI+sigEtJEWa14Rh9H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1314

Am 08.01.20 um 18:51 schrieb Alex Deucher:
> On Wed, Jan 8, 2020 at 12:39 PM Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Jan 08, 2020 at 01:56:47PM +0100, Christian König wrote:
>>> Am 07.01.20 um 20:25 schrieb Tianlin Li:
>>>> Right now several architectures allow their set_memory_*() family of
>>>> functions to fail, but callers may not be checking the return values.
>>>> If set_memory_*() returns with an error, call-site assumptions may be
>>>> infact wrong to assume that it would either succeed or not succeed at
>>>> all. Ideally, the failure of set_memory_*() should be passed up the
>>>> call stack, and callers should examine the failure and deal with it.
>>>>
>>>> Need to fix the callers and add the __must_check attribute. They also
>>>> may not provide any level of atomicity, in the sense that the memory
>>>> protections may be left incomplete on failure. This issue likely has a
>>>> few steps on effects architectures:
>>>> 1)Have all callers of set_memory_*() helpers check the return value.
>>>> 2)Add __must_check to all set_memory_*() helpers so that new uses do
>>>> not ignore the return value.
>>>> 3)Add atomicity to the calls so that the memory protections aren't left
>>>> in a partial state.
>>>>
>>>> This series is part of step 1. Make drm/radeon check the return value of
>>>> set_memory_*().
>>> I'm a little hesitate merge that. This hardware is >15 years old and nobody
>>> of the developers have any system left to test this change on.
>> If that's true it should be removed from the tree. We need to be able to
>> correctly make these kinds of changes in the kernel.
> This driver supports about 15 years of hardware generations.  Newer
> cards are still prevalent, but the older stuff is less so.  It still
> works and people use it based on feedback I've seen, but the older
> stuff has no active development at this point.  This change just
> happens to target those older chips.

Just a few weeks back we've got a mail from somebody using an integrated 
R128 in a laptop.

After a few mails back and force we figured out that his nearly 20 years 
old hardware was finally failing.

Up till that he was still successfully updating his kernel from time to 
time and the driver still worked. I find that pretty impressive.

>
> Alex
>
>>> Would it be to much of a problem to just add something like: r =
>>> set_memory_*(); (void)r; /* Intentionally ignored */.
>> This seems like a bad idea -- we shouldn't be papering over failures
>> like this when there is logic available to deal with it.

Well I certainly agree to that, but we are talking about a call which 
happens only once during driver load/unload. If necessary we could also 
print an error when something goes wrong, but please no larger 
refactoring of return values and call paths.

It is perfectly possible that this call actually failed on somebodies 
hardware, but we never noticed because the driver still works fine. If 
we now handle the error it is possible that the module never loads and 
the user gets a black screen instead.

Regards,
Christian.

>>
>>> Apart from that certainly a good idea to add __must_check to the functions.
>> Agreed!
>>
>> -Kees
>>
>> --
>> Kees Cook
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flists.freedesktop.org%2Fmailman%2Flistinfo%2Fdri-devel&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7Ca542d384d54040b5b0b708d794636df1%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637141027080080147&amp;sdata=EHFl6YOHmNp7gOqWsVmfoeD0jNirBTOGHcCP4efC%2FvE%3D&amp;reserved=0


Return-Path: <SRS0=3JLP=LT=lists.openwall.com=kernel-hardening-return-21319-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801D7C2B9F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 11:00:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 319E96144E
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 11:00:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 319E96144E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=windriver.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21319-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22178 invoked by uid 550); 25 Jun 2021 10:58:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30345 invoked from network); 25 Jun 2021 06:26:10 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1RhacBmFyuEwdARuRjhbDLI9PNCoAfr6cEg8S/I577y2KIfXrm+9FPLnYPSYPjTNtGWrMWFS9uXqxp1FU4djACmltzb3neKoMl2Y8xvVyHod2K+QCCJ5yxWThke+nfhCUOON2zQQoFJnmTprd/aEFZys9o/P2Sfu39dhqEbcXzyhHKIoXAX5emnniQp1bLdKbZRnw5Zza0oloCrJ75V9TxH/nFOm++yvE6wtQJgoo1qjnfHpiwopSMDKy7QR2cEq44/cqkNgr9eZxPdHBk7LkxKyBj7tkei2XgWIUnoVF/RVecVEFWEyMwDavL2JLYKIIwW1wumVNIqw61NydEgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFeU7A34Sfx5wy9feIjs0v7/tUWwRnXEZtvqxqdxXqQ=;
 b=n+o/YoX+L8/eKXVh+Ql/D5yucmCDAdXnlnFKKVguDS7H3boSD/csaE6kes+9SSZYeJFyzJ5ByN5Cwjf7fy42sBK1oVTBxyLIyNQ205ibtNzgVitDObMTIuJzMhfIvLKB9vHDOGhbSGJUIOgUViwsQlYaOObGDi0zaabLEQAOhHu2kEf5hLI75gE7H8OMW/6wkf7QsHZWQR4j3vZG69Il779cDfhI0CQpsfH8JrJMzN9vIFgl7CYjUjxV/p48Tzhpj6wgdJDj6eyqQVwZQLMG+47JX7IFTd2B1w4+XW7PnYYpH+4BUdxBtMruFcRtj8mIfpCEzW1qZrMAgIMuTmYReg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFeU7A34Sfx5wy9feIjs0v7/tUWwRnXEZtvqxqdxXqQ=;
 b=LKYbbYWE14WSYd/36BvdchnGMZhLizI/HWU8ePD4aP03oWHhRRI3FMbOT3BuI1vK7OeENg7PTznvOx6q+lH5fs6g23RABO01wGKC3+SA9x5AK0kvNB67ex5X2Md2L9aA3QJMO7ubLVS+u5qQKgxfBKuW4G+L/V1X9ArJHzdz6mA=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=windriver.com;
Subject: Re: [PATCH] seq_buf: let seq_buf_putmem_hex support len larger than 8
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        ying.xue@windriver.com, "Li, Zhiquan" <Zhiquan.Li@windriver.com>
References: <20210624131646.17878-1-yun.zhou@windriver.com>
 <20210624105422.5c8aaf4d@oasis.local.home>
 <32276a16-b893-bdbb-e552-7f5ecaaec5f1@windriver.com>
 <20210625000854.36ed6f2d@gandalf.local.home>
From: Yun Zhou <yun.zhou@windriver.com>
Message-ID: <133301fa-634b-e9b6-578e-08c16026f754@windriver.com>
Date: Fri, 25 Jun 2021 14:25:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20210625000854.36ed6f2d@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:203:c9::9) To SN6PR11MB3008.namprd11.prod.outlook.com
 (2603:10b6:805:cf::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98038a04-c0fb-4bc4-7603-08d937a205e9
X-MS-TrafficTypeDiagnostic: SN6PR11MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<SN6PR11MB259284E588A9BA97C09158A29F069@SN6PR11MB2592.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zaKn3aCFqaXpqfy4e5aUg1uUpPRFvJkwpCL3vjPiGMnuq7f9/2n/iS3MliPA13hgPkOvkz25SOYGBLAieqq9dWtZYhxXdrrkeZE74vBWM/3uq44mytgVQqr1eG0CsRocq4nR/pDav+xOXdtgtw0WPAStwi++leG+mUEXi/KbMROIebggQp7hL2SCEhHIEorVWGhrQGOpTCRxG7A0JF5/oAuJlfkakVU2GziF9Q0c3ZJItwW8XxWb+MBwgpus/YUqpB7MfqeQjPbi7W+tuURvCruR0roUbv1jV2aeJjWaVhmwDnU1lVDAB/cmHLICQzqvj63f2e0o4pmTImlw2zPzc1tXaJjgQBrgUa6EaLdOuE/EahkOmPDb3NaS4EYjLqeR1jshnMfvMtbxrmMLNqR5Q1+JELih++QatOL8UIr/lLvDLwoPB2EXcdHKErTCwxt5ZY6YK7mVfIs7k6F5K6QxkCfmiAM0M9atfSU5ct1pAVzhfsQVlsNdkvG7GCs2ItoVcUhu+wANsqkRTxJdTWgOU69vz0f/gS0DpKwFpPT7DZz6stSaJR99A3Ln63DMffHQXMqh8FuUTNNDgqWmLfak81ucz7/rqu19uM+RrLocRHaqAklO1/Rk+e4sUz+vQ0RGPgvMl+453oKDb3DfmgycYOfVz2wl6099J/B8NXCUgrRvoecjEYh5dUoxTr/+tCLPXEBgWYH3/FN61hr0iDnzCkmqFKF+QBxVwfhiZIqQ1KE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39840400004)(136003)(396003)(31696002)(44832011)(107886003)(31686004)(2906002)(86362001)(36756003)(4326008)(2616005)(38350700002)(38100700002)(316002)(956004)(478600001)(6706004)(5660300002)(66946007)(66476007)(16576012)(66556008)(83380400001)(52116002)(53546011)(8676002)(8936002)(6486002)(6916009)(16526019)(186003)(6666004)(26005)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MmdMZmc0cExQS3RkZ2s1L282cy94VmNqU3V3ZStBblJnRmlIcGpNM1FPM2Vo?=
 =?utf-8?B?UHhFNW5UOTduTGpsaG82TndVNUJQaWV0VGs2K3BtdHprLzR2OXN5UVlkZmRI?=
 =?utf-8?B?OWtFRUNra3B3QWFZOSt2LzNYeHlaYlFKUDJ0eHl3TDFtdnRmS1J6NUNVMmRS?=
 =?utf-8?B?dUxTT2E1T3c5MXBoMUZhU2ZSNFloamg1NmVsQnBjbHo1YjhSUnpLNTJTd0gx?=
 =?utf-8?B?WGYydWdlbkRRWkhUbkNyc1ZKNExTRk0xVnMrKzloR1lKSnAvcjYvUzd3eUcr?=
 =?utf-8?B?NFY0djVJeDZGWG9BRVNzK1ZtNzIxNEJjZm1YZDI2ck1zc2JXb25neE8xeXFC?=
 =?utf-8?B?d0hxM1RqdUtXYnNlUUh5dGlwTkZHZFZLR3FFSEVPcE90akdFb04rYWpZb3FP?=
 =?utf-8?B?NXBsWnRLajhSNWNjR2ZFeG1OeTA1WHVtOGlFNld6MXJDNnpOdjN5cGE4SExw?=
 =?utf-8?B?YUxjU25WS0t6cnh1QXRIb2pCUXlFYUFnbllCYXI4dUlrSmlHajJHZzhYbjFU?=
 =?utf-8?B?WjVUbWRYYlBqN21PSGMwRmlNbkgrMy9kN1l0NHJZd0dvQW1hUWc4VTVJM3Zv?=
 =?utf-8?B?QmtGVWZGT1M0Rk9ka2R0cDVRM1Q5eko4dkl6YkEySWFyVTh6U0JvZ1djallD?=
 =?utf-8?B?REZQQlF6S1ZUbUlVTW5pM1VBNVoxR1M1V0tSV0ptMjBNcXlJa3p3U0NpbmlD?=
 =?utf-8?B?Q2luZFMyeno2VW1TdVZwVklLU2NTOHkzamdoYkgwTVFZckRPTjkyeElSLzRN?=
 =?utf-8?B?Y3ZsQS8zaThWUVRHcmpXZzZnSXRTbWszTXhQRWFteGtIanJRTVdqRm5XMjdY?=
 =?utf-8?B?MXgyaDNMUXRkZG9ONWpoZWtTMCtyQkZ0cmVnS2xva2xjTG9aK3JlUVhEcGRk?=
 =?utf-8?B?SHlTYlNFMFZXZWkvUHdRS0JnWEduYjQ2anJKdVV6WGRWRlk1UGxrM0IvR3Zn?=
 =?utf-8?B?amJsUE5WRTBEQ2ZUQnpseE05M01xbWl4VWwyajAxN05vSnJMWlNhSUROd0lS?=
 =?utf-8?B?Q2VybHJxUnkrUWhsL2lBZnA5MzVtUmVneEZmcHFZR21WS1doeElPcWpvaG5i?=
 =?utf-8?B?WWNIaWRjSzZyU1M2YVRlTWw1dUdUcEZZcVp2cVNsQ1FDVmExWE5zUm84Ylpu?=
 =?utf-8?B?cU1yMUgzRHVQeEljREpLY0hGMlFBZ09qanZ5VFlMTHVSK0VsWDFncUgwMXJw?=
 =?utf-8?B?c2dvS2tYTUUvbFlDelRqSHo2YW9rOEZIZk53Qld2L2ZwVUxkVDFWV1MvRTFE?=
 =?utf-8?B?VElSVXpYbWFONmhpUlBmQ0hzalhhQmRzYnpKUG5UNjZydml0SzE0WHptdTlQ?=
 =?utf-8?B?RndhdWxEQU5NY3R2Nk9KVHNWcHo2bkR4aEw1Q2NlRldNeEk1VW43R1o0bTNm?=
 =?utf-8?B?S0hza1RJQ1RxcUVGbHpmeEJrK2lmWWVwSU5PSFFPS1p5bHZoL05lTDU2OXdq?=
 =?utf-8?B?a3ZMVWc1ajAxalh3NncrWnNqV2hkWEdVN1Z2V3lpTWVsOFFtYlJPN1VPclNY?=
 =?utf-8?B?TExtd3R1T2d4eW5LOWc1c1dOdm1weGRNYmN0OU9VYWkrTzlkSmRObHpoUmlL?=
 =?utf-8?B?RG5QVTZRR0M2clI4U1ZmUVBLaVh6dUdGL2VrTXdINEpVTmVuY1RJZ2tDZjFL?=
 =?utf-8?B?dGIxeHBjdm5rOUxjVURBazA0TGNxQTZ5RVc3eVhtVk53bkdGdklUS0tzUmpU?=
 =?utf-8?B?SzhudkVxL2xCV0NNWU1ia1RjTFVvZnhGMURoL3FXbXY1ZXhxMXVtZGIyVkxZ?=
 =?utf-8?Q?yZrVLFuQF+pplT6kcTzJ8MxOd5h0/rGIu6QygWH?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98038a04-c0fb-4bc4-7603-08d937a205e9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 06:25:27.5510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B83Qw5+F7i8PB2/FkXZbxFem7+nzbAsF+PheBNB0yL75BE/6E1S4yfsiBSMJP3/wCCOQRnxp4As5Z7as0OAe9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2592
X-Proofpoint-ORIG-GUID: Qi3iWl_8zISEViGH9HFDGNvVGaxzw8wM
X-Proofpoint-GUID: Qi3iWl_8zISEViGH9HFDGNvVGaxzw8wM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_02:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250035

Hi Steve,

I think my patch is the simplest way and has the least impact on 
original code.

If now we let it only support single word, there will be much 
modification, e.g.

1. The 'while' loop will have no longer meaning to exist. The following 
lines also

     need to be removed.

244         /* j increments twice per loop */
245         len -= j / 2;
246         hex[j++] = ' ';

2. We need to comment on both seq_buf_putmem_hex() and 
trace_seq_putmem_hex(),

     to prompt the caller not use more than 8 bytes of     data.

Please consider my solution carefully. Or, I will develop a new patch to 
request review.

Regards,

Yun

On 6/25/21 12:08 PM, Steven Rostedt wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Fri, 25 Jun 2021 11:41:35 +0800
> Yun Zhou <yun.zhou@windriver.com> wrote:
>
>> Hi Steve,
>>
>> Thanks very much for your friendly and clear feedback.
>>
>> Although in current kernel trace_seq_putmem_hex() is only used for
>> single word,
>>
>> I think it should/need support longer data. These are my arguments:
>>
>> 1. The design of double loop is used to process more data. If only
>> supports single word,
>>
>>       the inner loop is enough, and the outer loop and the following
>> lines are no longer needed.
>>
>>           len -= j / 2;
>>
>>           hex[j++] = ' ';
>>
>> 2. The last line above try to split two words/dwords with space. If only
>> supports single word,
>>
>>       this strange behavior is hard to understand.
>>
>> 3. If it only supports single word, I think parameter 'len' is redundant.
> Not really, we have to differentiate char, short, int and long long.
>
>> 4. The comments of both seq_buf_putmem_hex() and trace_seq_putmem_hex()
>> have not
>>
>>       indicated the scope of 'len'.
>>
>> 5. If it only supports single word, we need to design a new function to
>> support bigger block of data.
>>
>>        I think it is redundant since the current function can perfectly
>> deal with.
>>
>> 6. If follow my patch, it can support any length of data, including the
>> single word.
>>
>> How do you think?
> First, since you found a real bug, we need to just fix that first (single
> word as is done currently). Because this needs to go to stable, and what
> you are explaining above is an enhancement, and not something that needs to
> be backported.
>
> Second, is there a use case? Honestly, I never use the "hex" version of the
> output. That was only pulled in because it was implemented in the original
> code that was in the rt patch. I wish we could just get rid of it.
>
> Thus, if there's a use case for handling more than one word, then I'm fine
> with adding that enhancement. But if it is being done just because it can
> be, then I don't think we should bother.
>
> What use case do you have in mind?
>
> Anyway, please send just a fix patch, and then we can discuss the merits of
> this update later. I'd like the fix to be in ASAP.
>
> Thanks!
>
> -- Steve

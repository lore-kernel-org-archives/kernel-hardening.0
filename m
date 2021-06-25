Return-Path: <SRS0=2Fto=LT=lists.openwall.com=kernel-hardening-return-21318-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D02C2B9F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 11:00:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8FB6061425
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 11:00:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FB6061425
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=windriver.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21318-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19687 invoked by uid 550); 25 Jun 2021 10:58:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24231 invoked from network); 25 Jun 2021 03:42:28 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZqqoRjNper9IiPBY0gvCQG5sdyimqYVdBk8mQ5gxzlKvYU5Vc8TzPYv/yb+vinrAf/NxNMYuTxnAoF6lYP594igHkshDBNhxBO/AQt06cufYi67PN+BZeYpE5IGdzbMRZUW2q5NuaupBxNfN7xXkEwu9BjFZeamtTTowdM1Jr2WxRVKA5WSpvyqS9uvf+7KNnPQFBfe6A9box0t8EaCMo9qDCRgMhtpR+o0mAF6O3XKGXtezwOr9f7qT/J+8gLqhdsT0bJkzosm+YLtZBB21a8JAbtE2ENlzQEA2oJBoin+8kbjGYVTsNjtiqlY5NrPPvYvxED2ERJM9eP/FvoxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25S1cUnmsXd2vJA8DEvAwtZ0iNj37W8070jl1mFrQO8=;
 b=SkqAWB73OHeBzB8nlwxlp1eF1qcVfhDYeDAgrNKtsMuv7ANjfcdYcSSMHFizAvPEyX81lcDOi6hSAncRTZabnhqu9Xngde4gnJ/PIfKnWcM17BYEMyhyANSr1b2PNXca3W1+XXy8TOupTXZdYc6cBlJCW0IIrqtX4blNVu/R9WozamSkIxwO6D2PpQs4oQJHvIgfcZxYnRaJtV8lxq1mAsYH9zbvcv0d6rgAUdDZ3x9LMNfV7AuUqGhG/pfvJeVeHdEx8+4+6tYlTzbo61bIRPrjyzTUSDDoBAOLiWU92anOWZBIYTptt5x+SA2Q0BhpEnsPyZ6pbr5DaHxDgroEWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25S1cUnmsXd2vJA8DEvAwtZ0iNj37W8070jl1mFrQO8=;
 b=gApz7nGeYEPQoG/z8GoKDoc6ZrQuRXW+GXY45De6jRZmi1qOyQQims0OpHNpzqvRVGOHhz5v3Q9UXTl5BXfqiQ/laToCuLhOd4hesQ/lrceuiekB5sUiVxBt3Z98UzBBuWFm8aLL9NExnLJTeESuUr61C3feX3yX0XFQ+6eq4HY=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=windriver.com;
Subject: Re: [PATCH] seq_buf: let seq_buf_putmem_hex support len larger than 8
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        ying.xue@windriver.com, ps-ccm-rr@windriver.com
References: <20210624131646.17878-1-yun.zhou@windriver.com>
 <20210624105422.5c8aaf4d@oasis.local.home>
From: Yun Zhou <yun.zhou@windriver.com>
Message-ID: <32276a16-b893-bdbb-e552-7f5ecaaec5f1@windriver.com>
Date: Fri, 25 Jun 2021 11:41:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20210624105422.5c8aaf4d@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR03CA0114.apcprd03.prod.outlook.com
 (2603:1096:203:b0::30) To SN6PR11MB3008.namprd11.prod.outlook.com
 (2603:10b6:805:cf::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcdf40f1-f035-47ae-0762-08d9378b2751
X-MS-TrafficTypeDiagnostic: SA2PR11MB5196:
X-LD-Processed: 8ddb2873-a1ad-4a18-ae4e-4644631433be,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<SA2PR11MB5196DB820D83802D42EE105C9F069@SA2PR11MB5196.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:517;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ASrBnmr/8UECwmrYUmE9LyP8NyV8BJtEl5VRwKUFv2rHYUmVL2Yqfeww460rs8kYjLDjBPcSOAGRq6SKNA4q4mhUF47cs10IEGNxh37qglTPCqHfbqZYga397iGMSForm+vwCtBntn7kMjlbdIK6VQdkudJAiGiFl9S8rnMX+8WhoQEM74kSu9tkckhAYSO6UFyRJ8sbB7zWOy5PETE1q91mCp8dXX9TGRCeaxP6WmKcrQ3dfnBP/xjX0OyJhda7cJW/dsPCGrD8PZo2Z0tutAS23e8fCU8dumuRFZZhpZpBM6hO8fkIPwXVueezbsELc5r1Hc30o2x2DvWgMtfkuzNcGeThIo/+x61HeLPU9Cvv0kJZUbkpG6gkzsmhEum8Cnx1ApFI73Ywd6w4r6AiPPfj8BnlkNI0BuXVfg7VWRDTh+tUa9CwBe0fzPCQl5KSAMEYp/CnEcOSEk21VvTU+hCPYXe0/qY8Vlc3flr8Flj9RIn8oQyxNiXyTq0AFf6j9MK45eTEo9pPZMQPN62WX6SDnwnyX/+PV++Cd1ImH35v2rZLYzU3VR+hAwGSzLXf3Z0YHBDu1x7h5oci7RZMzXltIL22NTq/FJlw3APoLuuA49op8mLCONKSGvMfg47WlLOCkXYJ1H8o5UXKZdW1Yru6DG35obPvzY2+cuOXsOnHRGy4r509884UOBOFlYoLOjoinPtT76ipGm+6aL/yblqSs7w4IVdSAjKkQgXoUjoxDceesp8OmZMBAA2No7ieDPcjUTwqolO62lXiXeYkPCw5X5qG9oW0cARD8rg2YUY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(66556008)(36756003)(956004)(66946007)(2616005)(66476007)(53546011)(86362001)(16576012)(31686004)(44832011)(45080400002)(2906002)(478600001)(4326008)(31696002)(5660300002)(8936002)(107886003)(6666004)(6916009)(16526019)(52116002)(38350700002)(38100700002)(186003)(6706004)(316002)(6486002)(26005)(8676002)(83380400001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?a0p4di9wQlR5NEdvTVNCODRzWXlmT3NjeTZRclF0WlRrVEZlZHNKanpiYW9i?=
 =?utf-8?B?UnV4YWkxMVFRZU05azJHOUpLdklqVldzbjdZR3B3Nng0OWV3STNsYlRYam50?=
 =?utf-8?B?Q3hPZzdGd0QyblAyQ2VrQXRvTmx5OG40UWx6YUsxNVhZY1Vnd09CYXEwRDRm?=
 =?utf-8?B?WjNnR2xIU0UwZUdEb0N1Vm1KdXMvb2tUTk9mTE5yd0grLzdFbnVidlJlaXVK?=
 =?utf-8?B?dHhWdEFXSG42TDlYVEdsVDI5Y24wc2xYTFdhMUdGNUoxdlZNdFQ3a3Nrakhi?=
 =?utf-8?B?R1oxdFljMHAyMG4ybkhRZExyWUY0S1BOTWtpZVNJcE9DTjlXclpkaFlFUjQv?=
 =?utf-8?B?a2M2V3RyeXhteU1qSGt2V05mOUMvczdRcTJ6cmNsVThKZkhjUEpwbzdnOUt2?=
 =?utf-8?B?NEQyZUVHVE81V2gyRnFLaUM4T0JTc1N3WGNpTzRGTEFMRGxZUXJpeFNsSkYw?=
 =?utf-8?B?MTU2ZGh4T1dneEQ1ZjlWZ2swZ0tOWk5BaWRWRlpLaHZoaWVCRXl2VTdqMmRK?=
 =?utf-8?B?cEFhS01BTkIrYTlRNDlkN1padmNVdDMrbEF4a1hHUmhiWGFVRDZIL1BRUmU0?=
 =?utf-8?B?MUVWNi8xYU53WTVzSWhZU21MSXJYSUZWSWFDdUFJeG1hZm9tQk05NkNpYjdo?=
 =?utf-8?B?bnM1U003bnl5a0lLZnNzbWN1czhkVVlsZUZMK2hWekdyMnZOREJnaHFLcGxM?=
 =?utf-8?B?SnF2RU9mWkFTRGgrTTJCSGpTbDM5alZ1N3RGR241eHBlWlUyYjFpaHkyZ3g4?=
 =?utf-8?B?TFRSK0JRbDF4VDE2OWhwT2VWVHNlanNwc1ROSVlFM1ROMlhwVWs1QStnRlo1?=
 =?utf-8?B?UkhFYU53aERObjY2eEVSeE9meHhuK2hQZUxzNkVqWnpPSVdOQ0dKZ0tDQnBw?=
 =?utf-8?B?dzdTVGZMY1JocElzdnJaVE4vWmllQ0JqTW9kTmF0ZDhvNldFdkFNQWR6cDZ6?=
 =?utf-8?B?QytHczEyKzFIVFcwbTJBZ1J0M2UxMFArMDFNTVJScytFZUx0Nis0a2xRVThz?=
 =?utf-8?B?R2lUeC80ZmFRQ1gyTENISU1EcXdqdVhrTU9WNDZYajVTVDB3b202MCtrOC9l?=
 =?utf-8?B?ckh1Q00rM2J0NmpueEV0RmQ5bVF1VzV1NThCRWl0TmpNUmhkd09tVTBDbVEr?=
 =?utf-8?B?UklRQUZ1ckZzMzlxQUZ5N0V4eWxPR01wQnlCK2lMZVAyeGt0VlhyR2NJdExW?=
 =?utf-8?B?WjRhWUNtVFUxSU93VnRJWC9LbXZEQjZVU2JLZUtQTmhDZHhhc1cweG5uZzJp?=
 =?utf-8?B?bitvSit1TGZkSkhTdU9OZytIU0RDOVhNVlBBaVUyRUtjWmJGRURyc29YamdP?=
 =?utf-8?B?S2oybm5MaXNSRVdINXQ4bXFJc2RIcXAySktTdmdPWEY5S1lpRm9ZeFNtVnVG?=
 =?utf-8?B?STJncTRMUUNKWHJDMTVYYzRkZS9kN2x2dExvWmZrUHB2SzgzNUx6NXVIM1ZV?=
 =?utf-8?B?Rzg2Z2hiS0VVVnRBQ2t1RVdDQkc1TEpXb2dTT0tCR2pSWnFwYVpHQlZFNVho?=
 =?utf-8?B?YXFib3RaV1NZaS9XTUJFMnFmZHRjNTNhMFlFRHZqYk10aGRKWE5XWjk3dDZX?=
 =?utf-8?B?QmZvVk9kRkttb1NGK2ZRZjFDd0ZHdmVmc3NXQ25Nd3JMbHVXVzd6b0tEd0RD?=
 =?utf-8?B?dWhxTEQ3Y0NaRWZScTZkOEZRSTM5K1pNa2VlYm55Wkt2d0FxTnJaSk92eEV0?=
 =?utf-8?B?UXVocktxT3VDalR1K1E0S3ArQ1RiR3BSdlNnSytFQ1RUZlVWZk96VThUYitv?=
 =?utf-8?Q?A+fIg6Hpl4GH5aVhxgOGDLJ5fcw8mBsU9+FPfSg?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcdf40f1-f035-47ae-0762-08d9378b2751
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 03:41:45.1188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VgH/dFDDzAo8fWWe2+jZA9TzMDckIaJzXpyIZVfRPurXe+KoKQ28ca/jQE3cVIABHxth2g2FBhwdJo9S9I0hTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5196
X-Proofpoint-ORIG-GUID: -Ei0tBDfMggYzOuOaPRM0LcKVYN1GnBL
X-Proofpoint-GUID: -Ei0tBDfMggYzOuOaPRM0LcKVYN1GnBL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_01:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106250019

Hi Steve,

Thanks very much for your friendly and clear feedback.

Although in current kernel trace_seq_putmem_hex() is only used for 
single word,

I think it should/need support longer data. These are my arguments:

1. The design of double loop is used to process more data. If only 
supports single word,

     the inner loop is enough, and the outer loop and the following 
lines are no longer needed.

         len -= j / 2;

         hex[j++] = ' ';

2. The last line above try to split two words/dwords with space. If only 
supports single word,

     this strange behavior is hard to understand.

3. If it only supports single word, I think parameter 'len' is redundant.

4. The comments of both seq_buf_putmem_hex() and trace_seq_putmem_hex() 
have not

     indicated the scope of 'len'.

5. If it only supports single word, we need to design a new function to 
support bigger block of data.

      I think it is redundant since the current function can perfectly 
deal with.

6. If follow my patch, it can support any length of data, including the 
single word.

How do you think?

Regards,

Yun

On 6/24/21 10:54 PM, Steven Rostedt wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Thu, 24 Jun 2021 21:16:46 +0800
> Yun Zhou <yun.zhou@windriver.com> wrote:
>
>> I guess the original intention of seq_buf_putmem_hex is to dump the raw
> A little background, this was originally introduced in 2008:
>
>   5e3ca0ec76fce ("ftrace: introduce the "hex" output method")
>
> And commit ad0a3b68114e8 ("trace: add build-time check to avoid overrunning hex buffer")
>
> changed HEX_CHARS from a hardcoded 17 to a way to decided what the max
> long is.
>
>   #define HEX_CHARS              (MAX_MEMHEX_BYTES*2 + 1)
>
>
>> memory to seq_buf according to 64 bits integer number. It tries to output
>> numbers in reverse, with the high bits in the front and the low bits in
>> the back. If the length of the raw memory is equal to 8, e.g.
>> "01 23 45 67 89 ab cd ef" in memory, it will be dumped as "efcdab8967452301".
> Note, it only does that for little endian machines.
>
>> But if the length of the raw memory is larger than 8, the first value of
>> start_len will larger than 8, than seq_buf will save the last data, not
>> the eighth one, e.g. "01 23 45 67 89 ab cd ef 11" in memory, it will be
>> dumped as "11efcdab8967452301". I think it is not the original
>> intention of the function.
>>
>> More seriously, if the length of the raw memory is larger than 9, the
>> start_len will be larger than 9, then hex will overflow, and the stack will be
>> corrupted. I do not kown if it can be exploited by hacker. But I am sure
>> it will cause kernel panic when the length of memory is more than 32 bytes.
>>
>> [  448.551471] Unable to handle kernel paging request at virtual address 3438376c
>> [  448.558678] pgd = 6eaf278e
>> [  448.561376] [3438376c] *pgd=00000000
>> [  448.564945] Internal error: Oops: 5 [#2] PREEMPT ARM
>> [  448.569899] Modules linked in:
>> [  448.572951] CPU: 0 PID: 368 Comm: cat Tainted: G        W        4.18.40-yocto-standard #18
>> [  448.581374] Hardware name: Xilinx Zynq Platform
>> [  448.585901] PC is at trace_seq_putmem_hex+0x6c/0x84
>> [  448.590768] LR is at 0x20643032
>> [  448.593901] pc : [<c009a85c>]    lr : [<20643032>]    psr: 60000093
>> [  448.600159] sp : d980dc08  ip : 00000020  fp : c05f58cc
>> [  448.605375] r10: c05e5f30  r9 : 00000031  r8 : 00000000
>> [  448.610584] r7 : 20643032  r6 : 37663666  r5 : 36343730  r4 : 34383764
>> [  448.617103] r3 : 00001000  r2 : 00000042  r1 : d980dc00  r0 : 00000000
>> ...
>> [  448.907962] [<c009a85c>] (trace_seq_putmem_hex) from [<c010b008>] (trace_raw_output_write+0x58/0x9c)
>> [  448.917094] [<c010b008>] (trace_raw_output_write) from [<c00964c0>] (print_trace_line+0x144/0x3e8)
>> [  448.926050] [<c00964c0>] (print_trace_line) from [<c0098710>] (ftrace_dump+0x204/0x254)
>> [  448.934053] [<c0098710>] (ftrace_dump) from [<c0098780>] (trace_die_handler+0x20/0x34)
>> [  448.941975] [<c0098780>] (trace_die_handler) from [<c003cff8>] (notifier_call_chain+0x48/0x6c)
>> [  448.950581] [<c003cff8>] (notifier_call_chain) from [<c003d19c>] (__atomic_notifier_call_chain+0x3c/0x50)
>> [  448.960142] [<c003d19c>] (__atomic_notifier_call_chain) from [<c003d1cc>] (atomic_notifier_call_chain+0x1c/0x24)
>> [  448.970306] [<c003d1cc>] (atomic_notifier_call_chain) from [<c003d204>] (notify_die+0x30/0x3c)
>> [  448.978908] [<c003d204>] (notify_die) from [<c001361c>] (die+0xc4/0x258)
>> [  448.985604] [<c001361c>] (die) from [<c00173e8>] (__do_kernel_fault.part.0+0x5c/0x7c)
>> [  448.993438] [<c00173e8>] (__do_kernel_fault.part.0) from [<c043a270>] (do_page_fault+0x158/0x394)
>> [  449.002305] [<c043a270>] (do_page_fault) from [<c00174dc>] (do_DataAbort+0x40/0xec)
>> [  449.009959] [<c00174dc>] (do_DataAbort) from [<c0009970>] (__dabt_svc+0x50/0x80)
>>
>> Additionally, the address of data ptr keeps in the same value in multiple
>> loops, the value of data buffer will not be picked forever.
> So the bug looks like it was there since the original code was
> introduced in 2008! There's two variables being increased in that loop
> (i and j), and i follows the raw data, and j follows what is being
> written into the buffer. The bug is that we are comparing the HEX_CHARS
> to 'i' when we really should be comparing it to 'j'! As if 'j' goes
> bigger than HEX_CHARS, it will overflow the destination buffer.
>
> And, it should be noted, that this is to read a single word (long) and
> not more. Thus, the "date += start_len" shouldn't be needed.
>
> Could you send another patch that makes it only process a single word
> and exit?
>
> I'll tag it for stable when you do.
>
> Thanks!
>
> -- Steve
>
>
>> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
>> ---
>>   lib/seq_buf.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
>> index 6aabb609dd87..948c8b55f666 100644
>> --- a/lib/seq_buf.c
>> +++ b/lib/seq_buf.c
>> @@ -229,7 +229,7 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>>        WARN_ON(s->size == 0);
>>
>>        while (len) {
>> -             start_len = min(len, HEX_CHARS - 1);
>> +             start_len = min(len, MAX_MEMHEX_BYTES);
>>   #ifdef __BIG_ENDIAN
>>                for (i = 0, j = 0; i < start_len; i++) {
>>   #else
>> @@ -248,6 +248,8 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>>                seq_buf_putmem(s, hex, j);
>>                if (seq_buf_has_overflowed(s))
>>                        return -1;
>> +
>> +             data += start_len;
>>        }
>>        return 0;
>>   }

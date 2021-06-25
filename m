Return-Path: <SRS0=jBJm=LT=lists.openwall.com=kernel-hardening-return-21320-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16B3C2B9F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 11:00:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 99C6361425
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 11:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99C6361425
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=windriver.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21320-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22317 invoked by uid 550); 25 Jun 2021 10:59:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32601 invoked from network); 25 Jun 2021 07:43:37 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAmyjfIBxfWfSfuJUt6SN/vTmy/dDeivTMfHNIx+mowpb80JaKSFe827jKeaJi8g99CDlzWvrwg3TRvmqm3OdoEhwuiOoGAgqlT1+MP0MsQFsKibQ1a2f2qQB29yypJFZ7erjsDCUO27+d0fdSEu4aGrwvj7CkH2ValbOhZKzxqw0gEacwUPxs4QRwX03OQ5NQyJtH0ssHHd7UCfltbZ+KTXjmpX5V2X+U3wyQi9xneKhg6xauuLqRo/wzWfid4jWx78wDShXgXK8za7TwbDxbWKO/tOK4zLsx221ercWrArbl7ajENJbifK15I03c9oKEGMRKojMnGch6xtENRz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7x0XL3wHTqmHdVC5lI4fjtd2FVOJc+dAHJ/N13iUgDs=;
 b=faUWJNmTq6F2jGR5Co0V6tRq73MotLhfAS/xDdMfEBjn2xWYCtNtyDEYoKIHTWRWfDqe6shEt7n3bEYSC9AZr9YF/wANEghBwuBGsSq9fa3PG8Pimc4spV2P+b0cwWcg0FTnRBiy1nzxj6ON1QkARZL9YkjoSL7rwxsTDIyIlghCRzubyeXl0om8CBv5H/qI26CpZp0pWPEYZXlaIlyT/vRGzCJbGly17e/AFUDIn5DTBfUbHigVpUKb4JzVdXMVEx0L2sk5+WISrnh4QDfBh4EbjxUcmcymk5HELmN3agFgkFV5mFIcO0EMLpOfgB+g/CwxDUg8Sdvb3jMaOr5DWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7x0XL3wHTqmHdVC5lI4fjtd2FVOJc+dAHJ/N13iUgDs=;
 b=o5uqk0Cub/r2v+mLGCx6lq5PYYOEtRYTQoWCOGMkWWVTTaOHeORVKWRN6TTuWVKNs1W2x2nH6cTQ+jTUoASsf0xEaU8yGuh+E66/9ybYKg6tNPvzhzDfDJbnJH+ycIMsIO8zGFvuQlRPBUGjy9SX5b6nILDkq2h1aSR29qvnwjM=
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
Message-ID: <06010fbf-1d46-3313-1545-b75c42f19935@windriver.com>
Date: Fri, 25 Jun 2021 15:28:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20210625000854.36ed6f2d@gandalf.local.home>
Content-Type: multipart/alternative;
 boundary="------------47374347ADBB871AB1BB41F4"
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: BYAPR11CA0107.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::48) To SN6PR11MB3008.namprd11.prod.outlook.com
 (2603:10b6:805:cf::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6941e8a-7851-48e7-ecfe-08d937aad546
X-MS-TrafficTypeDiagnostic: SN6PR11MB2845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<SN6PR11MB28451E7D457276242A0274159F069@SN6PR11MB2845.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uGcGyJRzMSTEEVyAGwfqQXfItiohTSpc+QZNtfPTvG+TG6SDb+Oc0XW/J8NQoBcbeW7/rztu+CdxfDN4bXvaX6Qk6ep0WhltLePy35czu5NChh/zD2x291Kd17wzU1A4HYoNAx+QedfGn5IDoo2fREhejYDpUVJLuahe6gdGUGaTA87n4GqJxcqrD5VH8khmi//AVv+hpumw94gVkHN22/fuJ4+qQ2KxCgj6BjV/T7t2XSwaTzaglH+SIXJxxYI/g6HNY3xThInLeaUtr22fVP3KX6tE2rS8YbYoKsJl5PSaBHucI0C1VPSHSjAYWXUMhcah+cagy3gVo+wdB+xFPJhTdhCOHccQDTivurv2sGifyR617pYQBewtzyTAjsnwQ1n1vanRKclmuYsUCUlXEBSEoX48MTdOW+K4En0Dw35UOmOA8g84Y3OUROGpsf3Yes+PHhebpV6cG+ktvwH3MGMwg0xHxFO5c7ug/SidObaXX1dSS/XpZRGX+npJa6RrWeFiDFGfEGnz93iBsEIwbQhMUQYeMpU0OzmIxmR3/qbvf6Fn+FwUB97vILLINlsqiJ6YwlKA0U7pkcxBLwsbZHIQbzMAmKSHgEwmqVvwwvEsEqOt6FC7amf0f906m9QUN0pXh8oC3rHIn0REu8oD76C/xquLMSEtsgVpR2O2XoRzqbXYcl9pV8HDjvOkwCJRMh4w755nYRN1WMaY+u3SdmjeSWA9TshW+99/TxjgJNcz8UKtg07mcimLD9fgPhutLMzDqbWZ+P+Kh1auGCatUhUz2zYCjaIPgHIgB1fxa+A=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39850400004)(376002)(366004)(5660300002)(16576012)(186003)(16526019)(2616005)(8936002)(83380400001)(31686004)(956004)(66556008)(316002)(478600001)(8676002)(4326008)(36756003)(44832011)(53546011)(107886003)(38100700002)(38350700002)(26005)(66946007)(33964004)(6916009)(31696002)(86362001)(6486002)(52116002)(66476007)(6666004)(2906002)(6706004)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dnJIbHZCV3g1eTNXQkxvTS9hZW0wWStwcis4T25BdGVGS0swR1lxamJiMFNu?=
 =?utf-8?B?Z1ZxMmJzOFRjT2R4ekVkUW1RaFdMWEZTSnpYQU1Ya3ljU0tCL0VSK2NoT0pz?=
 =?utf-8?B?RVlzN2hMWmZRTk00ajlQcEFrcHdxSWg4M2tZT0NLVEttaWN6SmxKWlpTR3Jv?=
 =?utf-8?B?TUlVbnNiamdoWGIxUmE2bXU1OURVd3lydkFWZytBSmhTN1BHaUxUSG5PZFp3?=
 =?utf-8?B?RWZQNGZKZW5qT2VFOHFVZGZwT2FUb09GZkRlMUU5RWE3YXBKUzV0VWhYdzJP?=
 =?utf-8?B?N2FiVy9NY0pMd0lEWEprc1NDOVUzUnFxbHpuZEtFd3BzcG9oS2ZpbHhETng4?=
 =?utf-8?B?dzV2WkRlYWZWRHdzRHZuNnVxbUJrKy9xRFU2bFArTW13ZFNLNU5DS2d4c1FG?=
 =?utf-8?B?eXorYVBUSXFicG5oT2xSOU13ZndkMGJydTBoa0lsQ1BWb2g0UG1oa2x4RHpv?=
 =?utf-8?B?VUE4Vk83OWVZNG16YkxuMk1HTndCTU1pZzRuelp5RmVLejFvNEdPcGhWVU5k?=
 =?utf-8?B?Q2M1V1dnZWEvTFl0d25DVndTL2I2Q05PVmNRSUZFRDBYTUt3elR5bnZvRVZl?=
 =?utf-8?B?Q1pXam9HVkpFVm1xLzNEQkttU0JIOTlxNmVwdXlUdnJBMW1VdHloRkVmcVlj?=
 =?utf-8?B?OUxSZkNIUnRXNGFKK1pVVGp5U1JEWUZkdlRhMUhQa29QVHpiRklNK3dpNjVj?=
 =?utf-8?B?dlYra2l2L0RiM0VPaVJVU0Zjc01HQ3AvU0dWNWJCampqRWlyelZNUnI1djRi?=
 =?utf-8?B?b2p6bnV2Z1V1NUtmaGU1a0lLY1FiN2sxTHVrVTRyM1lkRHJ0SytSamZNU0pr?=
 =?utf-8?B?TUJnZHhUNUJZcnByUE9UdXNnOVBhb294eTFNRkZYeTZ0bHBackkxY1hESUwy?=
 =?utf-8?B?U2FyRENVZ0NOL2I1elBOaitOOU1MVkRuZTJ0Y3VXNGN4MTNLay9CUFpPTmpv?=
 =?utf-8?B?b2o5YVRXZUpGb3VZaUU1aXdsWFMxdVBXckpZY0x4bWZEUDJpcDVvMzZ4TDNE?=
 =?utf-8?B?Zm9tVlo2d1k2K1R6dmJsc3o1ekVQK3pCaWI0aUd1UGNUNGRqby9XYmMzYUdi?=
 =?utf-8?B?U0xueHVQbzl5eXNxdWhibmVtSlM2dVZVbm5OckRVdHQxZ3VuLzRpZXdrT3Zo?=
 =?utf-8?B?RTRrdmptMFRIVHlpN3J6WnNKM1VVWFhRNFdpSTZhV3g1aTJMQ1hXNEV2ejBD?=
 =?utf-8?B?SEo3V3JwWVFxSG9NMHlaQkFOUlVmbHNTbHRuMGQ2VGRHYWtwWkpDNC9MVTVE?=
 =?utf-8?B?Y3NwN3M5MGtGQUNXVXpDaC9XZ1Q1U3E4UitpY0JEdDJSL1BKUEJpSkZIM0kw?=
 =?utf-8?B?dlpyY2tnWTQwcG5Vb0Y1SXZoUFBUeTFpbmZvb00xUWtnTytpZlFONXgzOENN?=
 =?utf-8?B?RFozVk81T1dKeENYK1k4MjFNRTl3SGg4aG5tVmFLZm8yQXowU0ZWdUpidHVN?=
 =?utf-8?B?cjZLbW1CT1lsblJNMUdqWVU1Q2I3ODBjT2Iva3VGM3JWMmY2NXhQVHJ3Q0J5?=
 =?utf-8?B?Sm8vVVJDRWYwR2hEYUZqR0FmcTkrNGhKUGZzWVBrbFEvR09ac3RIRnFrTWg0?=
 =?utf-8?B?VEtEZzFDSXVPKzVSbldneVNOSHppTEJ5akZnNlQ1VGhjc29OL0JiL2p3SzRR?=
 =?utf-8?B?WDZ6dk9zRGtSTlo3UVJTYmVHZ2d2WFN2aHhWb3RHaSsyZ3pRdU9qZ2VWaHJp?=
 =?utf-8?B?Mlk3dElFY1lGWFRRTitQcFhzTzNDaVJrUUcybVpHWGhkQ29XVEtONjVVK1lN?=
 =?utf-8?Q?tt38KMi/4iel+LbdeD7E4X9gmg6mia1eECcMdxt?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6941e8a-7851-48e7-ecfe-08d937aad546
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 07:28:31.3618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwHquwZppUaYA0Kfwgp1ESN70A/kg+fFERITzH9Ybr911+7EmV6yvG+bONb2Hg4I9RM5/T95toTohkx476Dwag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2845
X-Proofpoint-ORIG-GUID: FMlzG_TZzEz49jo6V0u7iS7-gYuTSTLl
X-Proofpoint-GUID: FMlzG_TZzEz49jo6V0u7iS7-gYuTSTLl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_02:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250044

--------------47374347ADBB871AB1BB41F4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mr Steven,

I found that you had ever wanted to enhance trace_seq_putmem_hex() to

allow any size input(6d2289f3faa71dcc). Great minds think alike. Your

enhancement will let the function more robust, I think it is very advisable.

Now we only need modify two lines to solve a little flaw, and to let it

more more robust.

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

--------------47374347ADBB871AB1BB41F4
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <p>Hi Mr Steven,</p>
    <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px;
      margin-right:0px; -qt-block-indent:0; text-indent:0px;">I found
      that you had ever wanted to enhance trace_seq_putmem_hex() to</p>
    <p>
      <style type="text/css">
p, li { whi</style></p>
    <p> allow any size input(6d2289f3faa71dcc). Great minds think alike.
      Your</p>
    <p>enhancement will let the function more robust, I think it is very
      advisable.</p>
    <p>Now we only need modify two lines to solve a little flaw, and to
      let it</p>
    <p>more more robust.</p>
    <p>Regards,</p>
    <p>Yun<br>
    </p>
    <div class="moz-cite-prefix">On 6/25/21 12:08 PM, Steven Rostedt
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:20210625000854.36ed6f2d@gandalf.local.home">
      <pre class="moz-quote-pre" wrap="">[Please note: This e-mail is from an EXTERNAL e-mail address]

On Fri, 25 Jun 2021 11:41:35 +0800
Yun Zhou <a class="moz-txt-link-rfc2396E" href="mailto:yun.zhou@windriver.com">&lt;yun.zhou@windriver.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">Hi Steve,

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
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
Not really, we have to differentiate char, short, int and long long.

</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">
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
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
First, since you found a real bug, we need to just fix that first (single
word as is done currently). Because this needs to go to stable, and what
you are explaining above is an enhancement, and not something that needs to
be backported.

Second, is there a use case? Honestly, I never use the &quot;hex&quot; version of the
output. That was only pulled in because it was implemented in the original
code that was in the rt patch. I wish we could just get rid of it.

Thus, if there's a use case for handling more than one word, then I'm fine
with adding that enhancement. But if it is being done just because it can
be, then I don't think we should bother.

What use case do you have in mind?

Anyway, please send just a fix patch, and then we can discuss the merits of
this update later. I'd like the fix to be in ASAP.

Thanks!

-- Steve
</pre>
    </blockquote>
  </body>
</html>

--------------47374347ADBB871AB1BB41F4--

Return-Path: <SRS0=jHP9=Y6=lists.openwall.com=kernel-hardening-return-17319-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE24AC5DF63
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Nov 2019 16:59:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D2612187F
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Nov 2019 16:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D2612187F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17319-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5778 invoked by uid 550); 6 Nov 2019 16:59:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5741 invoked from network); 6 Nov 2019 16:59:26 -0000
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
To: KP Singh <kpsingh@chromium.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale
 <drysdale@google.com>,
        Florent Revest <revest@chromium.org>, James Morris <jmorris@namei.org>,
        Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>,
        bpf@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
 <20191106101558.GA19467@chromium.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <026b6f3f-d17a-d50e-4793-a76e6719cc1f@digikod.net>
Date: Wed, 6 Nov 2019 17:58:46 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20191106101558.GA19467@chromium.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 06/11/2019 11:15, KP Singh wrote:
> On 05-Nov 19:01, Mickaël Salaün wrote:
>> On 05/11/2019 18:18, Alexei Starovoitov wrote:

[...]

>>>
>>> I think the only way bpf-based LSM can land is both landlock and KRSI
>>> developers work together on a design that solves all use cases.
>>
>> As I said in a previous cover letter [1], that would be great. I think
>> that the current Landlock bases (almost everything from this series
>> except the seccomp interface) should meet both needs, but I would like
>> to have the point of view of the KRSI developers.
> 
> As I mentioned we are willing to collaborate but the current landlock
> patches does not meet the needs for KRSI:
> 
> * One program type per use-case (eg. LANDLOCK_PROG_PTRACE) as opposed to
>   a single program type. This is something that KRSI proposed in it's
>   initial design [1] and the new common "eBPF + LSM" based approach
>   [2] would maintain as well.

As ask in my previous email [1], I don't see how KRSI would efficiently
deal with other LSM hooks with a unique program (attach) type.

[1]
https://lore.kernel.org/lkml/813cedde-8ed7-2d3b-883d-909efa978d41@digikod.net/

> 
> * Landlock chooses to have multiple LSM hooks per landlock hook which is
>   more restrictive. It's not easy to write precise MAC and Audit
>   policies for a privileged LSM based on this and this ends up bloating
>   the context that needs to be maintained and requires avoidable
>   boilerplate work in the kernel.

Why do you think it is more restrictive or it adds boilerplate work? How
does KRSI will deal with more complex hooks than execve-like with
multiple kernel objects?


> 
> [1] https://lore.kernel.org/patchwork/project/lkml/list/?series=410101
> [2] https://lore.kernel.org/bpf/20191106100655.GA18815@chromium.org/T/#u
> 
> - KP Singh

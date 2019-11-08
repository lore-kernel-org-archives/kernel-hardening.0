Return-Path: <SRS0=Svl0=ZA=lists.openwall.com=kernel-hardening-return-17329-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F80DFA372C
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Nov 2019 15:40:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 871BA21D7E
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Nov 2019 15:40:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 871BA21D7E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17329-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28088 invoked by uid 550); 8 Nov 2019 15:40:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28054 invoked from network); 8 Nov 2019 15:40:41 -0000
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: KP Singh <kpsingh@chromium.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Drysdale <drysdale@google.com>,
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
 <20191105193446.s4pswwwhrmgk6hcx@ast-mbp.dhcp.thefacebook.com>
 <20191106100655.GA18815@chromium.org>
 <813cedde-8ed7-2d3b-883d-909efa978d41@digikod.net>
 <20191106214526.GA22244@chromium.org>
 <3e208632-e7ab-3405-5196-ab1d770e20c3@digikod.net>
 <5d0f1dc5-5a99-bd6a-4acc-0cdcd062a0c9@iogearbox.net>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <78b75ea3-3a7c-103c-ee00-a9c6c41bcd9c@digikod.net>
Date: Fri, 8 Nov 2019 16:39:55 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <5d0f1dc5-5a99-bd6a-4acc-0cdcd062a0c9@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 08/11/2019 15:34, Daniel Borkmann wrote:
> On 11/8/19 3:08 PM, Mickaël Salaün wrote:
>> On 06/11/2019 22:45, KP Singh wrote:
>>> On 06-Nov 17:55, Mickaël Salaün wrote:
>>>> On 06/11/2019 11:06, KP Singh wrote:
>>>>> On 05-Nov 11:34, Alexei Starovoitov wrote:
>>>>>> On Tue, Nov 05, 2019 at 07:01:41PM +0100, Mickaël Salaün wrote:
>>>>>>> On 05/11/2019 18:18, Alexei Starovoitov wrote:
> [...]
>>> * Use a single BPF program type; this is necessary for a key requirement
>>>    of KRSI, i.e. runtime instrumentation. The upcoming prototype should
>>>    illustrate how this works for KRSI - note that it’s possible to vary
>>>    the context types exposed by different hooks.
>>
>> Why a single BPF program type? Do you mean *attach* types? Landlock only
>> use one program type, but will use multiple attach types.
>>
>> Why do you think it is necessary for KRSI or for runtime instrumentation?
>>
>> If it is justified, it could be a dedicated program attach type (e.g.
>> BPF_LANDLOCK_INTROSPECTION).
>>
>> What is the advantage to have the possibility to vary the context types
>> over dedicated *typed* contexts? I don't see any advantages, but at
>> least one main drawback: to require runtime checks (when helpers use
>> this generic context) instead of load time checks (thanks to static type
>> checking of the context).
> 
> Lets take security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
> as one specific example here: the running kernel has its own internal
> btf_vmlinux and therefore a complete description of itself. From verifier
> side we can retrieve & introspect the security_sock_rcv_skb signatue

OK, this is indeed the signature defined by the kernel API. What happen
if this API change (e.g. if struct sock is replaced with a struct
sock_meta)?


> and
> thus know that the given BPF attachment point has struct sock and struct
> sk_buff as input arguments

How does the verifier know a given BPF attachment point for a program
without relying on its type or attach type? How and where is registered
this mapping?

To say it another way, if there is no way to differentiate two program
targeting different hook, I don't understand how the verifier could
check if a given program can legitimately call a helper which could read
the tracer and tracee fields (legitimate for a ptrace hook), whereas
this program may be attached to a sock_rcv_skb hook (and there is no way
to know that).


> which can then be accessed generically by the
> prog in order to allow sk_filter_trim_cap() to pass or to drop the skb.
> The same generic approach can be done for many of the other lsm hooks, so
> single program type would be enough there and context is derived
> automatically,
> no dedicated extra context per attach type would be needed and no runtime
> checks as you mentioned above since its still all asserted at verification
> time.

I mentioned runtime check because I though a helper should handle the
case when it doesn't make sense for a program attached to a specific
point/hook (e.g. ptrace) to use an input argument (e.g. sk) defined for
another point/hook (e.g. sock_rcv_skb).


> 
> Thanks,
> Daniel
> 

Thanks for this explanation Daniel.

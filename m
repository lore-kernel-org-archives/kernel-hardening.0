Return-Path: <kernel-hardening-return-21944-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id CF4A2C021A9
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Feb 2025 15:46:03 +0000 (UTC)
Received: (qmail 21926 invoked by uid 550); 17 Feb 2025 15:45:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21888 invoked from network); 17 Feb 2025 15:45:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1739807141; bh=Zpb2VQfhVcERHcagIIPwkdYYaV8LHvjypjKwYQxC+mw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=GyC2uvrJC9ufEH0IPzcZ/RnDjfU4cEKW0s/zmUpYCT/ySR6z8gUqegc64SW2Oz24KLVc0vODIZ9slL+JqG5CXhidFLzdGIl16S8DbD3qCa3IPy62rhDlDQUqT+Qmyw58DtpOSv0Pjmju63VqkblLn8z+Y2sGxqE07yXj7rm3ZfnEHuUMXPVkavWgg/6a+D9vQdIKGXRID1LyqWRoNymcS4h1fks/hbDKs4z495XJfepbcaJND460GQKTSpZpZ709TVppCGnO5+x1GfYzt/MkoPriZuLJv4TZOJgRnu5sVB8glo65W4f3eu3Jgy8VOs0Z2USq8o7lF/nKoKpHP7Eumw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1739807141; bh=Jx3r29zZhqLPYLQcOLNIn4GePP1wnf6YtDVTiyRGWCT=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=ovxUCeolxCIY8G1v8jbKA+I78JNxIyKlcSN9HTAZd6zc25Ui+xrPKfwbvHT5Ez6kVPBr2hlXWKMke18XaV6c/mxmufF8+Z3bgi1Hw2STHeV4DPxMhSCMym3UpdV+k7044AOKOWHYg+XQBuvEULtUM5HalX+h9vpeY0rfyvpEdd5v9JlKd0TsQXp/n9olKcCEtXhNMN5s5hbmYkFMoZfDEG9dWJEow4w6IWDvXvnqLtE25IN2v5VBKmscYkikH22vKNpqS1mGZF/i8S7gnH0ZSqJwk2YaGRPdP6fzSxVUUiH9ZDyVzp+rvIoq0iKZ1N5Mw42HCwlvyuzNopfoTcqIHg==
X-YMail-OSG: 0bH4v6gVM1kVlS_TSOnTiejnjDb__lMixZ5mpExKR5R1ZV4lrgDoaMFwJlBf7A1
 .D9pKpWXGNcpzHzpYxETYdkpySdmghlAy_BPJYgsUkGuLoajsgSUgRlFfC3F29iVSI37QhgZ.jpc
 hargzNxKatnM9Kqk2MZsILhaaDQ9TN45P3rdRtoKEPbl47xv2uQ.Jjzq5W_9GsQ2G9rLPE7B5K0T
 fi_atr7bMCdZcVHBtRYCr3_a.7NsYj7sxPoWdskeflrmpAV7owqfX1A4ezfvX3owm9C0VccZpyQB
 V0u0wbnowo80gkD0LzPWGAlE7PcGWs_xg47ZzpS5kOSGYXIBYN10G.EdSI_dYqmx2lZ6DXiWfjiB
 R092T1xWL2ezOlPn_m71rWJMdZx6qL4FRThwAcv_vwVabRGSNGlqX9Mgbnx_HWaDn9CuEkgWe8dz
 4D_UzHc3xTScKhyeEXROXdrKexQGRdu8DKbVtw04oenrjqGN0F_plNhYiS0euEcO1XvFEopuTq8Z
 Czpsi_VZJJngqxUuDwv1YQXj.vZ00fAviWg8IBKe3UWROXGpEUmJdt7SiDxdrbPPR.UEgLe2W7RB
 kezZNMxlok7cXCiZrwCi06TgF7O4nOV1WjDSWSDtaBolnPbRy9fd.rnoXm2eP2FF.6tSp8D.ZakW
 8.9lem5.rDMd6ajLCQX9ymh_euc6D4oSN.DHnItPO3GPoLDBj9jkxiv6N3GvjFfrAeL7qLnv_e.6
 TASR1UaFY5neHK5p_64.wIfw.C7GCVoBxB.g.Z.tO5st_XLtdrgEbV25tH7Y6mZUuZX8QDoI3ygs
 y77sSFPVgdYJK7KNoBH7TV1rnYUiafAS1_Vz1BTzdY.qhWAbDNATdZUlB4ViSv5ZrWW2Mlk31VP.
 H6TNa9Dsex0EU937oHT.RKuX9En_dunhyAsqyxsIa8E0iZ7RdLd5A9d7FcGdHcmo8hkgu9feqIsR
 I7FyXXK3w42INkJH_6n67hXNUCoCOZiPVrJjnJPhD3y5kHOTx81HmMMvnm2gG1hFhdAZZqqXeu1b
 X4MLY2YC.IjsY2JVQePOfnagYQ5wzryd2UpHXBPxkZG39FoIA225_znarBeWhrxGr3HIo.DGyK4h
 E2LntHfomAI1e6PBnkSPYpzQ4ap.22FfjZqef0U7vnUXapg0NLwLE7UQxC2mzCsIOMqSOI21j1Ft
 G5QlRbATtmt8jQsXJFPtGFwl481iJHGXHEa_K8FltIm18RK55AH52Dl_uaG6aRFeX_N3CYlHIwkS
 5OvC6nzaBtAU02drAmrF7jUcygEOlUkFSaq_rb2olPaMbuCHk8IXnUJXKzJ23.cyIT2eCJKiXBpZ
 OBTB5bSWcikgsrZ5M2IvVaSUWorEgZCeq46H3CqrFiqI.3pG65Qnvcsfv0iaqr3394Cin.3Q1uKb
 J55pxclHjmS40OfP7n8_qqi4xSrHtnxSGZ0SzcWTI8JO05KyKATKUh9gbsAvED608etnbAkwtucT
 mrp13y11R.GgOFXzb8boMpHAJryOAC2RXER3oIMd94OOf37P04at4sTMQ8v0FEkDEVrZraehSPBY
 4g6ZJ1l0dsc7U7602lJ05my03m8CN_4_7VdH25cdwVD9yPbTAGstpXJbbQU0j92P1CpGUajH_0M_
 oWTPCc4fKUjgVg9IzSeAjUmLtYKiw8FNfXZCXOgwPFOYWlB7Bqm_cP3IK.4MyoWIN7gQE5qC08a_
 ksJN43kB9OiajfZiDL0jHlSgT28qIyGVN.J5ciy5_rB_bR0czT0l7BD4eutzC1eT2kWKKAUVx7wa
 xjAQNPmALGNYtaj4IFQubyFRoqjGHiGObJVfR7msH3AAzEdASUnxhO_cKeA9hx6RG86jS8XUiRR6
 cX.5NH5tTc1avVKgCSXu6PbnbGISRjybyCtsgymWV9HCEEWQhPpS3bdoHJk6ebXnTX_Fvf_yIIbY
 WLDmn693pq.tPp9878fEpIPEhrvSFBgO4x9F9cvh.jdGflbSeU05RCChH_pbj71_g1t9b4K_rGb8
 YMkC.LzylkFu2zwzCErdKgEZRK_ZHRR0BYxsawkXoA4nBF_oQsivBMPgUs3Dp4.oNrgXl_sVrq97
 tys9suoIjgcU1ThuuY0yPRQzc3Sb5IBF_NR5jdVB4uX02ZPIpO3k.FXmKJVN_VKY2ITVZNdWYSqE
 HtC3mIffrzRUgL7V2IfOXTZ5iqSZ3W8AeuKNULU2.c3nTB6.qOjRW6GmnH3joSaxqqox.R23ipBX
 jeS3ITP1fVbAClPTRTKRJeSIcA3wuq4mPm7h03nLwe89lpvT1LJ.Vp1d7JHfwsrvyCXMTyTIQZtK
 YhMkjMOneROXrQw--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 5be9a88d-1e33-4b5a-8ae7-c419c1a8997d
Message-ID: <97506d0e-8487-4233-ab4f-78dc646b12cb@schaufler-ca.com>
Date: Mon, 17 Feb 2025 07:45:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Announce] Linux Security Summit North America 2025 CfP
To: "Dr. Greg" <greg@enjellic.com>, James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org,
 Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 linux-integrity@vger.kernel.org, lwn@lwn.net,
 Casey Schaufler <casey@schaufler-ca.com>
References: <35b17495-427f-549f-6e46-619c56545b34@namei.org>
 <20250217124538.GA11605@wind.enjellic.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20250217124538.GA11605@wind.enjellic.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.23369 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 2/17/2025 4:45 AM, Dr. Greg wrote:
> On Mon, Feb 10, 2025 at 01:03:02PM -0800, James Morris wrote:
>
> Good morning, I hope the week is starting well for everyone.
>
>> The Call for Participation for the 2025 Linux Security Summit North 
>> America (LSS-NA) is now open.
>>
>> LSS-NA 2025 is a technical forum for collaboration between Linux 
>> developers, researchers, and end-users. Its primary aim is to foster 
>> community efforts in deeply analyzing and solving Linux operating system 
>> security challenges, including those in the Linux kernel. Presentations 
>> are expected to focus deeply on new or improved technology and how it 
>> advances the state of practice for addressing these challenges.
>>
>> Key dates:
>>
>>     - CFP Closes:  Monday, March 10 at 11:59 PM MDT / 10:59 PM PDT
>>     - CFP Notifications: Monday, March 31
>>     - Schedule Announcement: Wednesday, April 2
>>     - Presentation Slide Due Date: Tuesday, June 24
>>     - Event Dates: Thursday, June 26 ??? Friday, June 27
>>
>> Location: Denver, Colorado, USA (co-located with OSS).
> I reflected a great deal before responding to this note and finally
> elected to do so.  Given the stated desire of this conference to
> 'focus deeply on new or improved technologies' for advancing the state
> of practice in addressing the security challenges facing Linux, and
> presumably by extension, the technology industry at large.
>
> I'm not not sure what defines membership in the Linux 'security
> community'.  I first presented at the Linux Security Summit in 2015,
> James you were moderating the event and sitting in the first row.
>
> If there is a desire by the Linux Foundation to actually promote
> security innovation, it would seem the most productive use of
> everyone's time would be to have a discussion at this event focusing
> on how this can best be accomplished in the context of the current
> Linux development environment.
>
> If we have done nothing else with our Quixote/TSEM initiative, I
> believe we have demonstrated that Linux security development operates
> under the 'omniscient maintainer' model, a concept that is the subject
> of significant discussion in other venues of the Linux community:
>
> https://lore.kernel.org/lkml/CAEg-Je9BiTsTmaadVz7S0=Mj3PgKZSu4EnFixf+65bcbuu7+WA@mail.gmail.com/
>
> I'm not here to debate whether that is a good or bad model.  I do
> believe, that by definition, it constrains the innovation that can
> successfully emerge to something that an 'omniscient' maintainer
> understands, feels comfortable with or is not offended by.
>
> It should be lost on no one that the history of the technology
> industry has largely been one of disruptive innovation that is
> completely missed by technology incumbents.
>
> The future may be the BPF/LSM, although no one has yet publically
> demonstrated the ability to implement something on the order of
> SeLinux, TOMOYO or Apparmor through that mechanism.  It brings as an
> advantage the ability to innovate without constraints as to would be
> considered 'acceptable' security.
>
> Unfortunately, a careful review of the LSM mailing list would suggest
> that the BPF/LSM, as a solution, is not politically popular in some
> quarters of the Linux security community.  There have been public
> statements that there isn't much concern if BPF breaks, as the concept
> of having external security policy is not something that should be
> supported.
>
> We took an alternative approach with TSEM, but after two years of
> submissions, no code was ever reviewed.

1. Not true.
2. I have suggested changes to the way you submit patches that will
   make reviewing your code easier. You have ignored these suggestions.
3. Recommendations have been made about your approach. Your arguments
   have been heard.

>   I'm not here to bitch about
> that, however, the simple fact is that two years with no progress is
> an eternity in the technology industry, particularly security, and
> will serve to drive security innovation out of the kernel.
>
> One can make a reasoned and informed argument that has already
> happened.  One of the questions worthy of debate at a conference with
> the objectives stated above.
>
> I apologize if these reflections are less than popular but they are
> intended to stimulate productive discussion, if the actual intent of
> the conference organizers is to focus deeply on new and improved
> security technology.

Please propose a talk for the summit. Talks have a limited duration,
so do be concise.

>
> There is far more technology potentially available than there are good
> answers to the questions as to how to effectively exploit it.
>
>> James Morris
>> <jmorris@namei.org>
> Best wishes for a productive week.
>
> As always,
> Dr. Greg
>
> The Quixote Project - Flailing at the Travails of Cybersecurity
>               https://github.com/Quixote-Project
>

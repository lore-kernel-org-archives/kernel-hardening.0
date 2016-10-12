Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
 <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 12 Oct 2016 15:31:33 -0700
Message-ID: <CAGXu5j+PLo0AHDWiG9pWhzS9fFgsJYNvbn96G=2tQq==9GPpaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] self introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 11, 2016 at 8:19 PM, Gengjia Chen <chengjia4574@gmail.com> wrote:
> Hi all,

Hi, welcome!

> My name is Jiayy (@chengjia4574). I am currently a security researcher in
> android and linux kernel. My researches  consist on hunting vulnerabilities
> in kernel code (most of them within drivers) and doing exploits using those
> vulns.
> I had found more than 40 vulnerabilities which were confirmed by Android
> Security Team
> in the past year. I also figured out some way to attack mitigation solutions
> of kernel
> (such as Bypass PXN).

In your research have you seen a common kind of bug that results in
the vulnerabilities you find? Is there anything that would have
significantly made exploitation more difficult in the things you
worked on?

> Those works help me get familiar with the kernel(device tree, memory
> management,
> network , some features especially those associated with security such as
> pxn, selinux, seccomp) and ARM instruction. However, it is not enough to get
> involved in real security development in kernel. Therefore, I am looking for
> task
> I can accomplish to be involved into real kernel development!  Recently I
> found
> this project (kernel self protection) and I thought it is so interesting.
>
> I don't know whether I can involve and  where I can begin, I am looking
> forward to
> your response.

Are you interested mostly in ARM-specific things? Are you interested
in kernel-assisted userspace defenses too?

-Kees

-- 
Kees Cook
Nexus Security

MIME-Version: 1.0
In-Reply-To: <20170210102359.GA30383@bifrost>
References: <20170210100902.11765-1-me@jessfraz.com> <20170210102359.GA30383@bifrost>
From: Jessica Frazelle <me@jessfraz.com>
Date: Fri, 10 Feb 2017 02:25:36 -0800
Message-ID: <CAEk6tEwnnXqsxkcpxch9axbTGou7i-MguHB9Ot+a9YCtWFccMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/4] set {msi_domain,syscore}_ops as __ro_after_init
To: Anisse Astier <anisse@astier.eu>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Thanks, ya I had planned on it, just didn't want to do that if this was wrong :)

On Fri, Feb 10, 2017 at 2:23 AM, Anisse Astier <anisse@astier.eu> wrote:
> Hi Jess,
>
> On Fri, Feb 10, 2017 at 02:08:58AM -0800, Jess Frazelle wrote:
>> This is an initial pass and sanity check to make sure this is correct. The
>> changes have all been tested on x86.
>
> May I suggested for the next iteration that you Cc: the
> maintainers/lists for each affected subsystem ?
>
> Regards,
>
> Anisse
>



-- 


Jessie Frazelle
4096R / D4C4 DD60 0D66 F65A 8EFC  511E 18F3 685C 0022 BFF3
pgp.mit.edu

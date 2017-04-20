MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAPDLWs_osmX=Rd_=bthrbf2zL=561LnJF+9ox7tP-+ANAhs+kg@mail.gmail.com>
References: <20170225003232.GA123380@beast> <1488011791.1141.1.camel@gmail.com>
 <CAGXu5jKbZZJxu0U_cy_UzxG9NtkEtTw2va7X=8AuwzQwAvkbjw@mail.gmail.com> <CAPDLWs_osmX=Rd_=bthrbf2zL=561LnJF+9ox7tP-+ANAhs+kg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 20 Apr 2017 13:58:57 -0700
Message-ID: <CAGXu5jJoid5Guiv4oCP2kL_p7sh0L2f=CdXJZcXvtpY6V0iGZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC] mm: enable sanitizing via CONFIG
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>, Daniel Micay <danielmicay@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 27, 2017 at 3:54 AM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> On Thu, Mar 2, 2017 at 12:46 AM, Kees Cook <keescook@chromium.org> wrote:
>> I'd love to see someone step up and create this for upstream. I think
>> it'd make a lot of sense instead of trying to shoe-horn things into
>> SLUB...
>>
> Ok, am unsure if I clearly understand all the issues involved; but of
> course it's always better to make a start and then evolve. So, how
> exactly can this be tackled? Do we go down the "new SLUB for security"
> path? And, if yes, then how exactly does one get started? I'll need
> some pointers pl...

Well, mainly it would need someone dedicated to creating a whole new
slab allocator for the kernel, and prioritizing security for it.
Daniel has a bunch of ideas on this, but I don't know enough currently
to make suggestions for what the design should look like. Making
sanity-checks fast would be a driving principle, though. :)

-Kees

-- 
Kees Cook
Pixel Security

MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170325014140.GB1251@athena>
References: <20170323025549.19588-1-ewk@edkovsky.org> <20170323025549.19588-2-ewk@edkovsky.org>
 <20170325004040.azlzgcmedusypah5@jeyu> <20170325014140.GB1251@athena>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 24 Mar 2017 18:58:58 -0700
Message-ID: <CAGXu5jKR0u21aqa+3eGcEZxRu2krnMqKprzgcRieuxN7wJNzCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 1/2] module: verify address is read-only
To: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 24, 2017 at 6:41 PM, Eddie Kovsky <ewk@edkovsky.org> wrote:
> On 03/24/17, Jessica Yu wrote:
>> +++ Eddie Kovsky [22/03/17 20:55 -0600]:
>> > Implement a mechanism to check if a module's address is in
>> > the rodata or ro_after_init sections. It mimics the exsiting functions
>> > that test if an address is inside a module's text section.
>> >
>> > Functions that take a module as an argument will be able to
>>
>> > verify that the module is in a read-only section.
>>
>> s/module/module address/?
>>
> Yes, that is more accurate.
>
>> Also, there is some useful information in your cover letter on the
>> context and motivation for adding to the api, it would be good to
>> reproduce that info here so that we can have it officially in the
>> changelog. (sentences "This implements a suggestion made by Kees..."
>> and "The idea is to prevent structures..." would be nice to copy here)
>>
> Okay, that's easy to add.
>
> Kees, would you like me to add your Suggested-by as well?

Sure! I'm find either way. :)

-Kees

-- 
Kees Cook
Pixel Security

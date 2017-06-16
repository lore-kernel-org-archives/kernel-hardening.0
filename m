References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-7-Jason@zx2c4.com>
 <20170608024357.fhyyentj2qm7ti2q@thunk.org>
 <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com>
From: Lee Duncan <lduncan@suse.com>
Message-ID: <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com>
Date: Fri, 16 Jun 2017 14:58:10 -0700
MIME-Version: 1.0
In-Reply-To: <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is
 seeded before use
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/08/2017 05:09 AM, Jason A. Donenfeld wrote:
> On Thu, Jun 8, 2017 at 4:43 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> What was the testing that was done for commit?  It looks safe, but I'm
>> unfamiliar enough with how the iSCSI authentication works that I'd
>> prefer getting an ack'ed by from the iSCSI maintainers or
>> alternativel, information about how to kick off some kind of automated
>> test suite ala xfstests for file systems.
> 
> Only very basic testing from my end.
> 
> I'm thus adding the iSCSI list to see if they'll have a look (patch reattached).
> 
> Jason
> 

It seems like what you are doing is basically "good", i.e. if there is
not enough random data, don't use it. But what happens in that case? The
authentication fails? How does the user know to wait and try again?
-- 
Lee Duncan
SUSE Labs

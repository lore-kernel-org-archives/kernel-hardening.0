Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 7 Sep 2011 15:01:46 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110907110146.GA11259@albatros>
References: <20110903111849.GA2743@albatros>
 <20110903235728.GD29169@openwall.com>
 <20110905124647.GA10247@albatros>
 <20110906050554.GA3889@openwall.com>
 <20110907090900.GA3910@albatros>
 <20110907093036.GA17693@openwall.com>
 <20110907093411.GA4752@albatros>
 <20110907094335.GA17834@openwall.com>
 <20110907095508.GA16114@albatros>
 <20110907101608.GA17974@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907101608.GA17974@openwall.com>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Sep 07, 2011 at 14:16 +0400, Solar Designer wrote:
> On Wed, Sep 07, 2011 at 01:55:08PM +0400, Vasiliy Kulikov wrote:
> > OK, fully agree.  But why 100 KB?  Probably 0x10000 (64 KB)?  It looks
> > nicer and not so magic.
> 
> Well, on Owl we have mmap_min_addr at 96 KB, which is sufficient e.g. in
> case we have a struct field offset not larger than 32 KB and the field
> itself is an array indexed by a 16-bit value.  Or if the field offset is
> not larger than 64 KB and the index is a signed 16-bit value.
> 
> 100 KB is a very cheap enhancement of the above, also allowing for two
> levels of indirection (up to one 16-bit signed and one 16-bit unsigned)
> relative to a fixed offset that fits in 4 KB.
> 
> Maybe we should move from 96 KB to 100 KB for Owl's mmap_min_addr
> default.  Or maybe we should use 132 KB (4+64+64).
> 
> Oh, this assumes arrays of char, or our 16-bit variable being byte
> offset rather than index.  132 KB would also support arrays of 16-bit
> words, and even 16-bit signed indexes into arrays of 32-bit words.
> 
> OK, maybe I am imagining these possibilities, but to me these values
> feel a little bit more reasonable than a mere 64 KB, which might be
> just insufficient e.g. if we have a 16-bit unsigned byte offset variable
> and the array itself is a struct field.  Even 68 KB would be a lot more
> likely to help then.

This calculation makes sense IMHO, but it assumes rather infrequent
scenario and I definitely don't want to start this discussion on LKML
(at least now).  0x20000 (128 KB) should be enough for our needs (the
128KB's byte belongs to ELF header, which is not writable) and it
doesn't look like a very magic number (any magic should be described in
the comment, which we don't exhaustively do even with the patch in
general ;) ).

So, I'll proceed with 0x20000.

Thanks,

-- 
Vasiliy

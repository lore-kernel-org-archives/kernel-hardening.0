From: Alexander Popov <alex.popov@linux.com>
Subject: Re: [PATCH 1/2] gcc-plugins: Update cgraph_create_edge for gcc-8
References: <20180222231442.29507-1-labbott@redhat.com>
 <20180222231442.29507-2-labbott@redhat.com>
 <CAGXu5j+eXU98vmERF+_7gfcNbkztav+JP3SJRexa=MLtyhb70Q@mail.gmail.com>
 <d09acf69-e9b5-43df-4a2b-9644b7c16ac7@redhat.com>
Message-ID: <595d7e78-4bd6-b36a-4abd-42e4dfedf7b0@linux.com>
Date: Sat, 24 Feb 2018 15:36:00 +0300
MIME-Version: 1.0
In-Reply-To: <d09acf69-e9b5-43df-4a2b-9644b7c16ac7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 23.02.2018 20:30, Laura Abbott wrote:
> On 02/22/2018 03:40 PM, Kees Cook wrote:
>> On Thu, Feb 22, 2018 at 3:14 PM, Laura Abbott <labbott@redhat.com> wrote:
>>>
>>> gcc-8 changed the API for cgraph_create_edge. Update accordingly.
>>>
>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>> ---
>>>   scripts/gcc-plugins/gcc-common.h | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
>>> index f46750053377..42c55c29157f 100644
>>> --- a/scripts/gcc-plugins/gcc-common.h
>>> +++ b/scripts/gcc-plugins/gcc-common.h
>>> @@ -723,8 +723,14 @@ static inline const char *get_decl_section_name(const_tree decl)
>>>   #define varpool_get_node(decl) varpool_node::get(decl)
>>>   #define dump_varpool_node(file, node) (node)->dump(file)
>>>
>>> +#if BUILDING_GCC_VERSION >= 8000
>>> +#define cgraph_create_edge(caller, callee, call_stmt, count, nest) \
>>> +       (caller)->create_edge((callee), (call_stmt), (count))
>>> +#else
>>>   #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
>>>          (caller)->create_edge((callee), (call_stmt), (count), (freq))
>>> +
>>> +#endif
>>
>> Since gcc 8 "throws away" the freq argument, could this just be
>> updated to do the same? i.e., leave "freq" as an argument, and just
>> don't use it? That way the plugin caller doesn't need to be updated.
>>
>> +#if BUILDING_GCC_VERSION >= 8000
>> +#define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
>> +       (caller)->create_edge((callee), (call_stmt), (count))
>> +#else
>>   #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
>>          (caller)->create_edge((callee), (call_stmt), (count), (freq))
>> +#endif
>>
> 
> Yeah, I think I started out that way then ended up with this for
> debugging reasons. The only concern I might have is ending up
> with the freq argument flagged as unused by gcc but I'm indifferent
> overall.

Hello Laura and Kees,

Laura, thanks a lot for your work! I double-checked gcc changelog and
agree with you. I will add this fix for gcc-8 as a separate commit
to the next version of STACKLEAK.

And I'll do some macro cleanup as well. All the cgraph_create_edge* macros
in gcc-common.h look strange.

At line 395 we have these redefinitions for dropping "nest":

 #if BUILDING_GCC_VERSION >= 4007 && BUILDING_GCC_VERSION <= 4009
 #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
 	cgraph_create_edge((caller), (callee), (call_stmt), (count), (freq))
 #define cgraph_create_edge_including_clones(caller, callee, old_call_stmt, call_stmt, count, freq, nest, reason) \
 	cgraph_create_edge_including_clones((caller), (callee), (old_call_stmt), (call_stmt), (count), (freq), (reason))
 #endif

But later at line 726 "nest" is not used as well:

 #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
 	(caller)->create_edge((callee), (call_stmt), (count), (freq))
 #define cgraph_create_edge_including_clones(caller, callee, old_call_stmt, call_stmt, count, freq, nest, reason) \
 	(caller)->create_edge_including_clones((callee), (old_call_stmt), (call_stmt), (count), (freq), (reason))

So I'm going to drop "nest" from cgraph_create_edge* macros and the plugin code.

Thanks again!
Best regards,
Alexander

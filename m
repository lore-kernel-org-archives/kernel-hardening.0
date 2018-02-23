Subject: Re: [PATCH 1/2] gcc-plugins: Update cgraph_create_edge for gcc-8
References: <20180222231442.29507-1-labbott@redhat.com>
 <20180222231442.29507-2-labbott@redhat.com>
 <CAGXu5j+eXU98vmERF+_7gfcNbkztav+JP3SJRexa=MLtyhb70Q@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <d09acf69-e9b5-43df-4a2b-9644b7c16ac7@redhat.com>
Date: Fri, 23 Feb 2018 09:30:28 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+eXU98vmERF+_7gfcNbkztav+JP3SJRexa=MLtyhb70Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/22/2018 03:40 PM, Kees Cook wrote:
> On Thu, Feb 22, 2018 at 3:14 PM, Laura Abbott <labbott@redhat.com> wrote:
>>
>> gcc-8 changed the API for cgraph_create_edge. Update accordingly.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>   scripts/gcc-plugins/gcc-common.h | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
>> index f46750053377..42c55c29157f 100644
>> --- a/scripts/gcc-plugins/gcc-common.h
>> +++ b/scripts/gcc-plugins/gcc-common.h
>> @@ -723,8 +723,14 @@ static inline const char *get_decl_section_name(const_tree decl)
>>   #define varpool_get_node(decl) varpool_node::get(decl)
>>   #define dump_varpool_node(file, node) (node)->dump(file)
>>
>> +#if BUILDING_GCC_VERSION >= 8000
>> +#define cgraph_create_edge(caller, callee, call_stmt, count, nest) \
>> +       (caller)->create_edge((callee), (call_stmt), (count))
>> +#else
>>   #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
>>          (caller)->create_edge((callee), (call_stmt), (count), (freq))
>> +
>> +#endif
> 
> Since gcc 8 "throws away" the freq argument, could this just be
> updated to do the same? i.e., leave "freq" as an argument, and just
> don't use it? That way the plugin caller doesn't need to be updated.
> 
> +#if BUILDING_GCC_VERSION >= 8000
> +#define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
> +       (caller)->create_edge((callee), (call_stmt), (count))
> +#else
>   #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
>          (caller)->create_edge((callee), (call_stmt), (count), (freq))
> +#endif
> 
> 
> -Kees
> 

Yeah, I think I started out that way then ended up with this for
debugging reasons. The only concern I might have is ending up
with the freq argument flagged as unused by gcc but I'm indifferent
overall.

Thanks,
Laura
